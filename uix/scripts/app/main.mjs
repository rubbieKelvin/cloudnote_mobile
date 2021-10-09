export function isMobileDevice(){
    return (Qt.platform.os === "android" || Qt.platform.os === "ios")
}

function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1) + min); //The maximum is inclusive and the minimum is inclusive
  }
  

export function randomDummyImage(){
    const path = "qrc:/uix/assets/images/dummy"
    return `${path}/${getRandomIntInclusive(1, 7)}.png`
}
