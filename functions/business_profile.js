const BUSINESS_NUMBER_WEIGHTS = [1, 3, 7, 1, 3, 7, 1, 3, 5];

function businessNumberDigits(value) {
  return typeof value === 'string' ? value.replace(/[^0-9]/g, '') : '';
}

function isValidBusinessNumber(value) {
  const digits = businessNumberDigits(value);
  if (digits.length !== 10) {
    return false;
  }
  let sum = 0;
  for (let i = 0; i < 9; i++) {
    sum += Number(digits[i]) * BUSINESS_NUMBER_WEIGHTS[i];
  }
  sum += Math.floor(Number(digits[8]) * 5 / 10);
  return (10 - (sum % 10)) % 10 === Number(digits[9]);
}

function formatBusinessNumber(value) {
  const digits = businessNumberDigits(value);
  return `${digits.slice(0, 3)}-${digits.slice(3, 5)}-${digits.slice(5)}`;
}

function validateBusinessRegisterRequest(data) {
  const companyName =
    data && typeof data.companyName === 'string' ? data.companyName.trim() : '';
  if (companyName.length === 0) {
    throw new Error('상호명이 비어 있습니다.');
  }
  const businessNumber = data && data.businessNumber;
  if (!isValidBusinessNumber(businessNumber)) {
    throw new Error('유효하지 않은 사업자등록번호입니다.');
  }
  const managerName =
    data && typeof data.managerName === 'string' ? data.managerName.trim() : '';
  const phone = data && typeof data.phone === 'string' ? data.phone.trim() : '';
  return {
    companyName,
    businessNumber: formatBusinessNumber(businessNumber),
    managerName,
    phone,
  };
}

module.exports = {
  isValidBusinessNumber,
  formatBusinessNumber,
  validateBusinessRegisterRequest,
};
