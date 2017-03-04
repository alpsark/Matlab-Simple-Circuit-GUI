This function takes the data in the "project.txt" and finds the voltages of nodes

Data must have following rule:
*Data will have a ground labeled as node 0.And other nodes will be labeled consecutively from 1 to n.
*The elements will be entered in a single row.
*The first column is the unique identifier for the element whose first letter indicates the element type:
*R,I or V and the rest is an integer.
*The second and the third columns denote the node numbers of the element.
*The last column denotes the value of the element in Ohms,Amperes or Volts.
*NodeNumber@SecondColumn < NodeNumber@ThirdColumn.
*Positive value for the current source means that the current is entering the Node@SecondColumn.
*Positive value for the voltage source means: Voltage of Node@SecondColumn < Voltage of Node@ThirdColumn.

After changing project.txt run project.m