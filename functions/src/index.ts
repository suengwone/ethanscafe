import {initializeApp} from "firebase-admin/app";
import {
  FieldValue,
  Timestamp,
  getFirestore,
} from "firebase-admin/firestore";
import {setGlobalOptions} from "firebase-functions/v2";
import {HttpsError, onCall} from "firebase-functions/v2/https";

initializeApp();
setGlobalOptions({region: "asia-northeast3", maxInstances: 10});

const EARN_RATE = 0.1;

interface PointHistoryEntry {
  id: string;
  type: "earn" | "use";
  description: string;
  amount: number;
  paymentAmount?: number;
  createdAt: Timestamp;
}

function generateEntryId(): string {
  return `${Date.now()}-${Math.floor(Math.random() * 0xffff)}`;
}

function generateMembershipId(): string {
  const digits = Array.from({length: 8}, () =>
    Math.floor(Math.random() * 10),
  ).join("");
  return `MEMBER-${digits}`;
}

export const earnPointsFromQr = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "로그인이 필요합니다.");
  }

  const rawCode = request.data?.code;
  if (typeof rawCode !== "string" || rawCode.trim().length === 0) {
    throw new HttpsError("invalid-argument", "QR 코드가 올바르지 않습니다.");
  }
  const code = rawCode.trim();

  const db = getFirestore();
  const tokenRef = db.collection("qrTokens").doc(code);
  const pointsRef = db.collection("points").doc(uid);

  return db.runTransaction(async (tx) => {
    const tokenSnap = await tx.get(tokenRef);
    if (!tokenSnap.exists) {
      throw new HttpsError("not-found", "등록되지 않은 QR 코드입니다.");
    }

    const token = tokenSnap.data() ?? {};
    if (token.used === true) {
      throw new HttpsError("failed-precondition", "이미 사용된 QR 코드입니다.");
    }
    const expiresAt =
      token.expiresAt instanceof Timestamp ? token.expiresAt.toDate() : null;
    if (expiresAt !== null && expiresAt.getTime() < Date.now()) {
      throw new HttpsError("failed-precondition", "만료된 QR 코드입니다.");
    }
    const paymentAmount =
      typeof token.paymentAmount === "number" ?
        Math.trunc(token.paymentAmount) :
        0;
    if (paymentAmount <= 0) {
      throw new HttpsError("failed-precondition", "결제 금액이 올바르지 않습니다.");
    }
    const storeName =
      typeof token.storeName === "string" && token.storeName.length > 0 ?
        token.storeName :
        "매장 결제";

    const pointsSnap = await tx.get(pointsRef);
    const points = pointsSnap.data() ?? {};
    const membershipId =
      typeof points.membershipId === "string" && points.membershipId.length > 0 ?
        points.membershipId :
        generateMembershipId();
    const previousBalance =
      typeof points.balance === "number" ? points.balance : 0;
    const history: PointHistoryEntry[] = Array.isArray(points.history) ?
      points.history :
      [];

    const earned = Math.floor(paymentAmount * EARN_RATE);
    const balance = previousBalance + earned;
    const entry: PointHistoryEntry = {
      id: generateEntryId(),
      type: "earn",
      description: storeName,
      amount: earned,
      paymentAmount,
      createdAt: Timestamp.now(),
    };

    tx.set(pointsRef, {
      membershipId,
      balance,
      history: [entry, ...history],
    });
    tx.update(tokenRef, {
      used: true,
      usedBy: uid,
      usedAt: FieldValue.serverTimestamp(),
    });

    return {storeName, paymentAmount, earned, balance};
  });
});
