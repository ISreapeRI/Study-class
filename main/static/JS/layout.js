var isOpened = false;
var isMoving = false;

function moveSide() {
    if (!isMoving) {
        isMoving = !isMoving;
        let id = null;
        // Получаем доступ к элементу по его классу
        myObj = document.getElementsByClassName('slide')[0];
        let pos;

        if (!isOpened) {
            pos = 0;
        } else {
            pos = 350;
        }

        clearInterval(id);

        // Задаем интервал для анимации появления боковой панели
        id = setInterval(movingFrame, 8)

        function movingFrame() {

            if (pos === 450 && !isOpened) {
                clearInterval(id);
                myObj.style.borderRight = "solid #010440 " + 5 + "px";
                isOpened = !isOpened;
                isMoving = !isMoving;
            } else if (pos === 0 && isOpened) {
                clearInterval(id);
                myObj.style.borderRight = "solid #010440 " + 0;
                isOpened = !isOpened;
                isMoving = !isMoving;
            } else {
                // Задаем направление анимации
                if (!isOpened) {
                    pos = pos + 25;
                } else {
                    pos = pos - 25;
                }

                myObj.style.left = pos - 450 + "px";
            }
        }
    }
}



