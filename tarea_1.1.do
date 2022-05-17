/*
	Tarea 1 Teoría Econométrica I
	Pregunta 1
	Autor: Alexander Valenzuela
*/

clear all

* 1.
set obs 1000
gen Y = rnormal(10000, 50)
gen C = 0.9 * Y

* 2.
reg C Y

* 3.
gen epsilon_1 = rnormal(0, 5)
gen Y_1 = Y + epsilon_1
reg C Y_1

* 4.
gen Y_2 = Y_1 + 100
reg C Y_2

* 5.
gen epsilon_2 = rnormal(0, 50)
gen C_1 = C + epsilon_2
reg C_1 Y

* 6.
gen Z = rnormal(150, 25)
gen C_2 = 0.9 * Y - 0.25 * Z
reg C_2 Y Z

* 7.
gen C_3 = C_2 + epsilon_2
reg C_3 Y Z

* 8.
reg C_3 Y
reg C_3 Z

* 9.
gen epsilon_3 = rnormal(10, 5)
gen W = 0.9 * Y + epsilon_3
corr W Y
gen epsilon_4 = rnormal(0, 50)
gen C_4 = 0.9 * Y - 0.25 * W + epsilon_4
reg C_4 Y W

* 10.
reg C_4 Y
reg C_4 W

* 11.
reg C_3 Y Z, nocons

* 12.
drop if _n > 50
reg C Y
reg C Y_1
reg C_1 Y
reg C_3 Y Z
reg C_4 Y W


