include std/rand.e

-- Inicio mi variable global 
-- NOTA: No habrá problema en que las tareas actualicen esta variable
-- ya que no suceden los errores comunes de los threads cuando un thread
-- es switcheado por otro y ya luego no le hace la modificación que iba a hacer
-- antes del swicth, esto es por el sistema de tareas "cooperativas" de 
-- Euphoria, la cual al switchear las tareas, las deja en un punto seguro, ya que
-- no se hace a la fuerza.
integer cont = 0

--Implemento el tipo booleano ya que no es un tipo del lenguaje
constant TRUE = 1, FALSE = 0

type boolean(integer x)
	return x = 0 or x = 1
end type

boolean t_run = TRUE

-- Se implementa un procedimiento para almacenar los resultados del producto punto
-- Args:
--   v1 (integer): Componente de uno de los vectores del producto punto
--   v2 (integer): Componente de uno de los vectores del producto punto
procedure producto(integer v1, integer v2)
    cont = cont + v1*v2
    task_yield()
    t_run = FALSE
end procedure

-- Se inicializan dos vectores
sequence vec1 = {}
sequence vec2 = {}

integer n = rand(100)

-- Se agregan elementos a los vectores
for i = 1 to n do
    vec1 = vec1 & {rand(100)}
    vec2 = vec2 & {rand(100)}
end for

atom t1

-- Por cada componente de crea una tarea para multiplicar y almacenar el valor
for j = 1 to n do
    t1 = task_create(routine_id("producto"), {vec1[j], vec2[j]})
    task_schedule(t1, {0, 0})
end for

-- Se mantiene el programa ejecutándose mientras aun no acaban todas las tareas
while t_run do
    if get_key() = 'q' then
		exit
	end if
	task_yield()
end while

-- En las siguientes líneas se imprimen los vectores generados y el resultado del producto punto
-- Se tiene que hacer la impresión manual ya que el lenguaje no provee una manera para iterar secuencias
puts(1, "[")
for j = 1 to n-1 do
    printf(1, "%d,", vec1[j])
end for
printf(1, "%d", vec1[n])
puts(1, "]\n")

puts(1, "[")
for j = 1 to n-1 do
    printf(1, "%d,", vec2[j])
end for
printf(1, "%d", vec2[n])
puts(1, "]\n")

printf(1, "%d", cont)
