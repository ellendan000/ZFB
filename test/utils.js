exports.assertVMException = error => {
  const hasException = error.toString().search("VM Exception") !== -1;
  assert(hasException, "Should expect a VM Exception error");
};