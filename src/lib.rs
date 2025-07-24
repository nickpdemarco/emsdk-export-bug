#[no_mangle]
pub extern "C" fn trigger_bug() {
    panic!("bug");
}
