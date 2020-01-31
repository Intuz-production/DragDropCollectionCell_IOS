<h1>Introduction</h1>
INTUZ is presenting an interesting Custom DragCollectionFlowLayout Control to integrate inside your native iOS-based application. 
DragCollectionFlowLayout is a simple component, which lets you drag and drop collectionviewcell using the long press in the cell. 
You will update the source and destination position of the array list.

<br/><br/>
<h1>Features</h1>

- Easy & Fast Integrate drag and drop collectionviewcell.
- You can drag and drop cells in both vertical and horizontal directions.
- You can update the source and destination position of the array list.
- Fully customizable layout.

<div style="float:left">
<img src="Screenshots/Screen1.png" width="200">
<img src="Screenshots/Screen2.png" width="200">
<img src="Screenshots/Screen3.png" width="200">
</div>


<br/><br/>
<h1>Getting Started</h1>

To use this component in your project you need to perform the below steps:

> Steps to Integrate


1) Add `DragCollectionView` at the required place on your code.

2) Add below code where you want to Integrate drag and drop feature in the controller:

*Set collectionViewLayout as DragCollectionFlowLayout in viewDidLoad:
```
    yourCollectionView.collectionViewLayout = DragCollectionFlowLayout()
    if let layout = yourCollectionView.collectionViewLayout as? DragCollectionFlowLayout {
        layout.scrollDirection = .vertical //.horizontal
    }
```

* Add UICollectionViewDelegateFlowLayout protocol and configure the below method:
```
    ///Enable collection view move property
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    ///handle source and destination position of cell
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceItem = itemList[sourceIndexPath.item]
        itemList[sourceIndexPath.item] = itemList[destinationIndexPath.item]
        itemList[destinationIndexPath.item] = sourceItem
        collectionView.reloadData()
    }
```

**Note:** Make sure you must bind uicollectionview dataSource and dataDelege method from a storyboard or you can set programmatically.


<br/><br/>
**<h1>Bugs and Feedback</h1>**
For bugs, questions and discussions please use the Github Issues.


<br/><br/>
**<h1>License</h1>**
The MIT License (MIT)
<br/><br/>
Copyright (c) 2020 INTUZ
<br/><br/>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
<br/><br/>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<br/>
<h1></h1>
<a href="https://www.intuz.com/" target="_blank"><img src="Screenshots/logo.jpg"></a>



