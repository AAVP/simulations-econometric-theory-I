/*
	Tarea 1 Teoría Econométrica I
	Problema 2
	Autor: Alexander Valenzuela
*/

clear all
cd "/Users/avalenzuela/Library/CloudStorage/OneDrive-uc.cl/9no_semestre/[EAE] Teoría Econométrica I/Tareas/Tarea 1/Histogramas sin constante"

scalar sigma_x1 = 100
scalar beta_0 = 10
scalar beta_1 = 2.5
scalar beta_2 = -1.5

program simulation_epsilon1, rclass
	args sample_size sigma_x1 beta_0 beta_1 beta_2
	set obs 500
	gen x_1 = rnormal(0, `sigma_x1')
	gen x_2 = rchi2(1)
	gen epsilon = rnormal(0, 1)
	gen y = `beta_0' + `beta_1' * x_1 + `beta_2' * x_2 + epsilon
	reg y x_1 x_2 if _n <= `sample_size', nocons
	return scalar b_1 = _b[x_1]
	return scalar b_2 = _b[x_2]
	test x_1 + x_2 = 1
	return scalar wt = r(F)
	drop _all
end

program simulation_epsilon2, rclass
	args sample_size sigma_x1 beta_0 beta_1 beta_2
	set obs 500
	gen x_1 = rnormal(0, `sigma_x1')
	gen x_2 = rchi2(1)
	gen epsilon = runiform(0, 1)
	gen y = `beta_0' + `beta_1' * x_1 + `beta_2' * x_2 + epsilon
	reg y x_1 x_2 if _n <= `sample_size', nocons
	return scalar b_1 = _b[x_1]
	return scalar b_2 = _b[x_2]
	test x_1 + x_2 = 1
	return scalar wt = r(F)
	drop _all
end

program simulation_epsilon3, rclass
	args sample_size sigma_x1 beta_0 beta_1 beta_2
	set obs 500
	gen x_1 = rnormal(0, `sigma_x1')
	gen x_2 = rchi2(1)
	gen epsilon = rchi2(1)
	gen y = `beta_0' + `beta_1' * x_1 + `beta_2' * x_2 + epsilon
	reg y x_1 x_2 if _n <= `sample_size', nocons
	return scalar b_1 = _b[x_1]
	return scalar b_2 = _b[x_2]
	test x_1 + x_2 = 1
	return scalar wt = r(F)
	drop _all
end

program simulation_epsilon4, rclass
	args sample_size sigma_x1 beta_0 beta_1 beta_2
	set obs 500
	gen x_1 = rnormal(0, `sigma_x1')
	gen x_2 = rchi2(1)
	gen epsilon = rpoisson(0.1)
	gen y = `beta_0' + `beta_1' * x_1 + `beta_2' * x_2 + epsilon
	reg y x_1 x_2 if _n <= `sample_size', nocons
	return scalar b_1 = _b[x_1]
	return scalar b_2 = _b[x_2]
	test x_1 + x_2 = 1
	return scalar wt = r(F)
	drop _all
end

foreach reps in 50 100 500 {
	foreach sample_size in 50 100 500 {
		forvalues i = 1(1)4 {
			set obs 500
			if `i' == 1 {
				simulate b_1=r(b_1) b_2=r(b_2) wald_test=r(wt), reps(`reps'): simulation_epsilon1 `sample_size' sigma_x1 beta_0 beta_1 beta_2
				local distribution = "Normal(0,1)"
			}
			else if `i' == 2 {
				simulate b_1=r(b_1) b_2=r(b_2) wald_test=r(wt), reps(`reps'): simulation_epsilon2 `sample_size' sigma_x1 beta_0 beta_1 beta_2
				local distribution = "Uniforme(0,1)"
			}
			else if `i' == 3 {
				simulate b_1=r(b_1) b_2=r(b_2) wald_test=r(wt), reps(`reps'): simulation_epsilon3 `sample_size' sigma_x1 beta_0 beta_1 beta_2
				local distribution = "{&chi}{sup:2}(1)"
			}
			else if `i' == 4 {
				simulate b_1=r(b_1) b_2=r(b_2) wald_test=r(wt), reps(`reps'): simulation_epsilon4 `sample_size' sigma_x1 beta_0 beta_1 beta_2
				local distribution = "Poisson(1/10)"
			}
			hist b_1, frequency title("") ytitle("Frecuencia") xtitle("{&beta}{sub:1} estimado") name(b_1)
			hist b_2, frequency title("") ytitle("Frecuencia") xtitle("{&beta}{sub:2} estimado") name(b_2)
			hist wald_test, frequency title("") ytitle("Frecuencia") xtitle("Estadístico test de Wald") name(wt)
			graph combine b_1 b_2 wt, title("Repeticiones: `reps', Tamaño muestra: `sample_size', {&epsilon}{&sim} `distribution'")
			graph export `reps'-`sample_size'-`i'.pdf, replace
			graph drop _all
		}
	}
}
	