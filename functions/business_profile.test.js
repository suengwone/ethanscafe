const test = require('node:test');
const assert = require('node:assert/strict');

const {
  isValidBusinessNumber,
  formatBusinessNumber,
  validateBusinessRegisterRequest,
} = require('./business_profile');

test('체크섬이 맞는 사업자등록번호를 통과시킨다', () => {
  assert.equal(isValidBusinessNumber('220-81-62517'), true);
  assert.equal(isValidBusinessNumber('2208162517'), true);
  assert.equal(isValidBusinessNumber(' 220 81 62517 '), true);
});

test('체크섬이 틀리거나 형식이 아닌 번호를 거부한다', () => {
  const invalid = [
    '123-45-67890',
    '220-81-62518',
    '123',
    '',
    null,
    undefined,
    1234567890,
  ];
  for (const value of invalid) {
    assert.equal(isValidBusinessNumber(value), false);
  }
});

test('사업자등록번호를 000-00-00000 형식으로 포맷한다', () => {
  assert.equal(formatBusinessNumber('2208162517'), '220-81-62517');
  assert.equal(formatBusinessNumber('220-81-62517'), '220-81-62517');
});

test('올바른 등록 요청을 정규화해 반환한다', () => {
  const result = validateBusinessRegisterRequest({
    companyName: ' 카페 어라운드 ',
    businessNumber: '2208162517',
    managerName: ' 김사장 ',
    phone: ' 010-1234-5678 ',
  });

  assert.deepEqual(result, {
    companyName: '카페 어라운드',
    businessNumber: '220-81-62517',
    managerName: '김사장',
    phone: '010-1234-5678',
  });
});

test('선택 입력이 없으면 빈 문자열로 채운다', () => {
  const result = validateBusinessRegisterRequest({
    companyName: '카페',
    businessNumber: '220-81-62517',
  });

  assert.deepEqual(result, {
    companyName: '카페',
    businessNumber: '220-81-62517',
    managerName: '',
    phone: '',
  });
});

test('상호명이나 사업자등록번호가 올바르지 않으면 거부한다', () => {
  const bodies = [
    null,
    {},
    {companyName: '  ', businessNumber: '220-81-62517'},
    {companyName: '카페', businessNumber: '123-45-67890'},
    {companyName: '카페', businessNumber: ''},
    {companyName: '카페'},
  ];
  for (const data of bodies) {
    assert.throws(() => validateBusinessRegisterRequest(data));
  }
});
