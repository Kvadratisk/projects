 window.addEventListener("touchstart", handleStart, false);
  window.addEventListener("touchend", handleEnd, false);
  window.addEventListener("touchcancel", handleCancel, false);
  window.addEventListener("touchmove", handleMove, false);

function handleMove(e) {
  e.preventDefault();
 if (mouseStatus) {
  var touches = e.changedTouches;
  bip.style.left = (touches[0].pageX - 25)+"px";
  bip.style.top = (touches[0].pageY - 25)+"px";
 }
}

function handleCancel(e) {
  e.preventDefault();
  mouseStatus=false;
}

function handleStart(e) {
  e.preventDefault();
   mouseStatus=true;
}

function handleEnd(e) {
  e.preventDefault();
  mouseStatus=false;
}
