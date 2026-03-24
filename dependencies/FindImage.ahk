FindImage(imageName, clickCoordsX := 0, clickCoordsY := 0) {
    imagePath := A_ScriptDir "\..\images\" imageName ".png"
    If ImageSearch(&x, &y, 0, 0, A_ScreenWidth, 1920, "*90 " imagePath) {
        Click(x + clickCoordsX, y + clickCoordsY)
        return true
    }
    else {
        ToolTipTimer("Could not find image", 5)
        return false
    }
}