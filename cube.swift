//: Playground - noun: a place where people can play
import UIKit
var str = "Hello, playground"
//2x2 rubik's cube
enum RubikColor:  Int {
   case red = 0
   case blue
   case green
   case yellow
   case white
   case orange
   case unknown
}
enum Axis: Int {
   case x = 0
   case y
   case z
   case unknown
}
enum Direction: Int {
   case anticlockwise = 0
   case clockwise
   case unknown
}
enum FaceEnumT:Int {
   case front = 0
   case right
   case top
   case back
   case left
   case bottom
}
struct Face {
   let rows: Int
   let columns: Int
   var grid: [RubikColor]
   
   init(rows: Int, columns: Int) {
      self.rows = rows
      self.columns = columns
      grid = Array(repeating: RubikColor.unknown, count: rows * columns)
   }
   
   init(rows: Int, columns: Int, rubikColor: RubikColor) {
      self.rows = rows
      self.columns = columns
      grid = Array(repeating: rubikColor, count: rows * columns)
   }
   
   func indexIsValid(row: Int, column: Int) -> Bool {
      return row >= 0 && row < rows && column >= 0 && column < columns
   }
   
   subscript(row: Int, column: Int) -> RubikColor {
      get {
         assert(indexIsValid(row: row, column: column), "Index out of range")
         return grid[(row * columns) + column]
      }
      set {
         assert(indexIsValid(row: row, column: column), "Index out of range")
         grid[(row * columns) + column] = newValue
      }
   }
   
   func facePrint() {
      for i in 0..<rows {
         for j in 0..<columns {
            print(self[i, j])
         }
      }
   }
   
}
typealias RubiksCube = [Face]
func findRubikColor(i: Int) -> RubikColor {
   switch(i) {
   case 0: return RubikColor.red
   case 1: return RubikColor.blue
   case 2: return RubikColor.green
   case 3: return RubikColor.yellow
   case 4: return RubikColor.white
   case 5: return RubikColor.orange
   default:
      return RubikColor.unknown
   }
}
func setupRubiksCube(numFaces: Int, rows: Int, columns: Int) -> [Face] {
   var rubiksCube = [Face]()
   for i in 0..<numFaces {
      let rubikColor: RubikColor = findRubikColor(i: i)
      print(rubikColor, i)
      rubiksCube.append(Face(rows: rows, columns: columns, rubikColor: rubikColor))
   }
   return rubiksCube
}
func printRubiksCube(rCube: RubiksCube) -> Void {
   for i in 0..<rCube.count {
      print(i)
      rCube[i].facePrint()
   }
}
func findFace(rCube: RubiksCube, faceEnum: FaceEnumT, rowOrColumn: Int, direction: Direction) -> Face {
   return rCube[0]
}
func recomposeRubiksCube(front2:Face, right2:Face, top2:Face, back2:Face, left2:Face, bottom2:Face) -> RubiksCube {
   
   var newCube = setupRubiksCube(numFaces: 6, rows: 2, columns:2)
   
   newCube[FaceEnumT.front.rawValue] = front2
   newCube[FaceEnumT.right.rawValue] = right2
   newCube[FaceEnumT.top.rawValue] = top2
   newCube[FaceEnumT.back.rawValue] = back2
   newCube[FaceEnumT.left.rawValue] = left2
   newCube[FaceEnumT.bottom.rawValue] = bottom2
   return newCube
}
func isometricClockwise(unknownFace:Face, columns:Int)->Face
{
   var unknownFace2:Face = unknownFace
   for i in 0..<columns {
      unknownFace2.grid[columns-1-i] = unknownFace.grid[columns*i]
      unknownFace2.grid[(columns-1)+(columns*i)] = unknownFace.grid[i]
      unknownFace2.grid[(columns*columns)-1-i] = unknownFace.grid[(columns-1)+(columns*i)]
      unknownFace2.grid[columns*i] = unknownFace2.grid[(columns*(columns-1))+i]
   }
   return unknownFace2
}
func isometricAntiClockwise(unknownFace:Face,columns:Int)->Face
{
   var unknownFace2:Face=unknownFace
   for i in 0..<columns{
      unknownFace2.grid[columns*i]=unknownFace.grid[columns-1-i]
      unknownFace2.grid[i]=unknownFace.grid[(columns-1)+(columns*i)]
      unknownFace2.grid[(columns-1)+(columns*i)]=unknownFace.grid[(columns*columns)-1-i]
      unknownFace2.grid[(columns*(columns-1))+i]=unknownFace2.grid[columns*i]
   }
   return unknownFace2
}
func isometricRotate(unknownFace : Face , direction : Direction ,noColumns : Int) -> Face{
   if ( direction==Direction.clockwise){
      return isometricClockwise(unknownFace: unknownFace, columns:noColumns)
   }
   else{
      return isometricAntiClockwise(unknownFace:unknownFace,columns:noColumns)
   }
}
func rotateCube(rCube: RubiksCube, rows: Int, columns: Int, axis: Axis, rowOrColumn: Int, direction: Direction) -> RubiksCube {
   if (rowOrColumn < 0 || rowOrColumn >= rows) {
      print("You are an idiot")
      return rCube
   }
   print("rowOrColumn is \(rowOrColumn)")
   print("axis is \(axis)")
   print("direction is \(direction)")
   
   
   //x,-1 : bottom => front, front => top, top => back, back => bottom, index-column
   if (axis==Axis.x&&direction==Direction.anticlockwise){
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         front2[i, rowOrColumn] = rCube[FaceEnumT.bottom.rawValue][i, rowOrColumn]
         top2[i, rowOrColumn] = rCube[FaceEnumT.front.rawValue][i, rowOrColumn]
         back2[i, rowOrColumn] = rCube[FaceEnumT.top.rawValue][i, rowOrColumn]
         bottom2[i, rowOrColumn] = rCube[FaceEnumT.back.rawValue][i, rowOrColumn]
      }
      if rowOrColumn==0 {
         left2 = isometricRotate(unknownFace : rCube[FaceEnumT.left.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      else{
         right2 = isometricRotate(unknownFace : rCube[FaceEnumT.right.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
      
   }
      //x,1 :  front => bottom, top => front, back => top, bottom => back, index
   else  if (axis==Axis.x&&direction==Direction.clockwise){
      
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         bottom2[i, rowOrColumn] = rCube[FaceEnumT.front.rawValue][i, rowOrColumn]
         front2[i, rowOrColumn] = rCube[FaceEnumT.top.rawValue][i, rowOrColumn]
         top2[i, rowOrColumn] = rCube[FaceEnumT.back.rawValue][i, rowOrColumn]
         back2[i, rowOrColumn] = rCube[FaceEnumT.bottom.rawValue][i, rowOrColumn]
      }
      
      if rowOrColumn==0 {
         left2 = isometricRotate(unknownFace : rCube[FaceEnumT.left.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      else{
         right2 = isometricRotate(unknownFace : rCube[FaceEnumT.right.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
   }
      //y,-1 : front => right, right => back, back => left, left => front, index
      
   else  if (axis==Axis.y&&direction==Direction.anticlockwise){
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         right2[rowOrColumn,i] = rCube[FaceEnumT.front.rawValue][rowOrColumn,i]
         front2[rowOrColumn,i] = rCube[FaceEnumT.left.rawValue][rowOrColumn,i]
         left2[rowOrColumn,i] = rCube[FaceEnumT.back.rawValue][rowOrColumn,i]
         back2[rowOrColumn,i] = rCube[FaceEnumT.right.rawValue][rowOrColumn,i]
      }
      
      if rowOrColumn==0 {
         top2 = isometricRotate(unknownFace : rCube[FaceEnumT.top.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      else{
         bottom2 = isometricRotate(unknownFace : rCube[FaceEnumT.bottom.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
   }
      //y, 1 : front => left, left => back, back => right, right => front, index
      
   else  if (axis==Axis.y&&direction==Direction.clockwise){
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         front2[rowOrColumn,i] = rCube[FaceEnumT.right.rawValue][rowOrColumn,i]
         left2[rowOrColumn,i] = rCube[FaceEnumT.front.rawValue][rowOrColumn,i]
         back2[rowOrColumn,i] = rCube[FaceEnumT.left.rawValue][rowOrColumn,i]
         right2[rowOrColumn,i] = rCube[FaceEnumT.back.rawValue][rowOrColumn,i]
      }
      
      if rowOrColumn==0 {
         top2 = isometricRotate(unknownFace : rCube[FaceEnumT.top.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      else{
         bottom2 = isometricRotate(unknownFace : rCube[FaceEnumT.bottom.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
   }
      //z, -1: right => top, top => left, left => bottom, bottom => right, index
      
   else  if (axis==Axis.z&&direction==Direction.anticlockwise){
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         top2[columns-rowOrColumn-1,i] = rCube[FaceEnumT.right.rawValue][i,rowOrColumn]
         left2[i,rowOrColumn] = rCube[FaceEnumT.top.rawValue][columns-rowOrColumn-1,i]
         bottom2[columns-rowOrColumn-1,i] = rCube[FaceEnumT.left.rawValue][i,rowOrColumn]
         right2[i,rowOrColumn] = rCube[FaceEnumT.bottom.rawValue][columns-rowOrColumn-1,i]
      }
      
      if rowOrColumn==0 {
         front2 = isometricRotate(unknownFace : rCube[FaceEnumT.front.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      else{
         back2 = isometricRotate(unknownFace : rCube[FaceEnumT.back.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
   }
      
      
      
      //z, 1, : right => bottom, bottom => left, left = top, top => right, index
   else  if (axis==Axis.z&&direction==Direction.clockwise){
      var front2: Face = rCube[FaceEnumT.front.rawValue]
      var top2: Face = rCube[FaceEnumT.top.rawValue]
      var back2: Face = rCube[FaceEnumT.back.rawValue]
      var bottom2: Face = rCube[FaceEnumT.bottom.rawValue]
      var left2: Face = rCube[FaceEnumT.left.rawValue]
      var right2: Face = rCube[FaceEnumT.right.rawValue]
      
      
      for i in 0..<columns {
         bottom2[columns-rowOrColumn-1,i] = rCube[FaceEnumT.right.rawValue][i,rowOrColumn]
         right2[i,rowOrColumn] = rCube[FaceEnumT.top.rawValue][columns-rowOrColumn-1,i]
         top2[columns-rowOrColumn-1,i] = rCube[FaceEnumT.left.rawValue][i,rowOrColumn]
         left2[i,rowOrColumn] = rCube[FaceEnumT.bottom.rawValue][columns-rowOrColumn-1,i]
      }
      
      if rowOrColumn==0 {
         front2 = isometricRotate(unknownFace : rCube[FaceEnumT.front.rawValue],direction:Direction.clockwise,noColumns:columns)
      }
      else{
         back2 = isometricRotate(unknownFace : rCube[FaceEnumT.back.rawValue],direction:Direction.anticlockwise,noColumns:columns)
      }
      
      return recomposeRubiksCube(front2: front2, right2: right2, top2: top2, back2: back2, left2: left2, bottom2: bottom2)
   }
   
   return rCube
   /*
    switch (axis) {
    case .x:
    let face0
    = findFace(rCube: rCube, faceEnum: FaceEnumT.front, rowOrColumn:rowOrColumn, direction: direction)
    default:
    let a = 0
    }
    */
}
let rows = 2
let columns = rows
let rubiksCube = setupRubiksCube(numFaces: 6, rows: rows, columns: columns)
printRubiksCube(rCube: rubiksCube)
//Testing
//X-axis anticlockwise
let rowOrColumn = 1
/*
let rubiksCube2 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube2)
let rubiksCube3 = rotateCube(rCube: rubiksCube2, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube3)
let rubiksCube4 = rotateCube(rCube: rubiksCube3, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube4)
let rubiksCube5 = rotateCube(rCube: rubiksCube4, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube5)
//X-axis clockwise
let rubiksCube6 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube6)
let rubiksCube7 = rotateCube(rCube: rubiksCube6, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube7)
let rubiksCube8 = rotateCube(rCube: rubiksCube7, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube8)
let rubiksCube9 = rotateCube(rCube: rubiksCube8, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube9)
// Y-axis anticlockwise
let rubiksCube10 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube10)
let rubiksCube11 = rotateCube(rCube: rubiksCube10, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube11)
let rubiksCube12 = rotateCube(rCube: rubiksCube11, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube12)
let rubiksCube13 = rotateCube(rCube: rubiksCube12, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube13)
//Y-axis clockwise
let rubiksCube14 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube14)
let rubiksCube15 = rotateCube(rCube: rubiksCube14, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube15)
let rubiksCube16 = rotateCube(rCube: rubiksCube15, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube16)
let rubiksCube17 = rotateCube(rCube: rubiksCube16, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube17)
//Z-axis anticlockwise
let rubiksCube18 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube18)
let rubiksCube19 = rotateCube(rCube: rubiksCube18, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube19)
let rubiksCube20 = rotateCube(rCube: rubiksCube19, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube20)
let rubiksCube21 = rotateCube(rCube: rubiksCube20, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube21)
//Z-axis clockwise
let rubiksCube22 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube22)
let rubiksCube23 = rotateCube(rCube: rubiksCube22, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube23)
let rubiksCube24 = rotateCube(rCube: rubiksCube23, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube24)
let rubiksCube25 = rotateCube(rCube: rubiksCube24, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.clockwise)
//printRubiksCube(rCube: rubiksCube25)
*/
//X-Y rotation
let rubiksCube26 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube26)
let rubiksCube27 = rotateCube(rCube: rubiksCube26, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
//printRubiksCube(rCube: rubiksCube27)
//X-Z rotation
let rubiksCube28 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.x, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
printRubiksCube(rCube: rubiksCube28)
let rubiksCube29 = rotateCube(rCube: rubiksCube26, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
printRubiksCube(rCube: rubiksCube29)
//Y-Z rotation
let rubiksCube30 = rotateCube(rCube: rubiksCube, rows: rows, columns: columns, axis: Axis.y, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
printRubiksCube(rCube: rubiksCube28)
let rubiksCube31 = rotateCube(rCube: rubiksCube26, rows: rows, columns: columns, axis: Axis.z, rowOrColumn: rowOrColumn, direction: Direction.anticlockwise)
printRubiksCube(rCube: rubiksCube29)
