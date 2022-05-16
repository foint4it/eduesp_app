import sqlite3
conn = sqlite3.connect('escuelas.db') #,check_same_thread=False)
c = conn.cursor()

# Database
# Table
# Field/Columns
# DataType


def view_all_insp():
	c.execute('SELECT InspeccionId,UnidadId,Nombre_Unidad,InspeccionDate,Observacion,Prioridad,Apoyo,ApoyoId,Nombre_Completo FROM vw_inspeccion')
	data = c.fetchall()
	return data

def view_all_insp_cab():
	c.execute('SELECT InspeccionId,UnidadId,Nombre_Unidad,InspeccionDate,Observacion,Prioridad,Apoyo FROM vw_inspeccion_cab')
	data = c.fetchall()
	return data


def add_insp_cab(unidad,fecha,obs,prioridad,apoyo):
    c.execute('INSERT INTO inspeccion(UnidadId,InspeccionDate,Observacion,PrioridadId,Apoyo) VALUES (?,?,?,?,?)',(unidad,fecha,obs,prioridad,apoyo))
    conn.commit()
    c.execute('SELECT MAX(InspeccionId) FROM inspeccion')
    data = c.fetchall()
    return data[0]

def add_insp_det(insp, prof_apoyo):
    c.execute('INSERT INTO inspeccion_apoyo(InspeccionId,ApoyoId) VALUES (?,?)',(insp,prof_apoyo))
    conn.commit()
    

def view_all_unidades():
	c.execute('SELECT DISTINCT UnidadId || "-" || Descripcion as Unidad FROM unidad_especial')
	data = c.fetchall()
	return data

def view_all_prioridades():
	c.execute('SELECT DISTINCT PrioridadId || "-" || Nombre as Prioridad FROM prioridad')
	data = c.fetchall()
	return data

def view_all_apoyo():
    c.execute('select distinct PersonalId || "-" || Nombre_Completo || "-" || Funcion as Apoyo from vw_apoyo_especial')
    data = c.fetchall()
    return data

"""
def view_all_data():
	c.execute('SELECT * FROM taskstable')
	data = c.fetchall()
	return data

def view_all_task_names():
	c.execute('SELECT DISTINCT task FROM taskstable')
	data = c.fetchall()
	return data

def get_task(task):
	c.execute('SELECT * FROM taskstable WHERE task="{}"'.format(task))
	data = c.fetchall()
	return data

def get_task_by_status(task_status):
	c.execute('SELECT * FROM taskstable WHERE task_status="{}"'.format(task_status))
	data = c.fetchall()


def edit_task_data(new_task,new_task_status,new_task_date,task,task_status,task_due_date):
	c.execute("UPDATE taskstable SET task =?,task_status=?,task_due_date=? WHERE task=? and task_status=? and task_due_date=? ",(new_task,new_task_status,new_task_date,task,task_status,task_due_date))
	conn.commit()
	data = c.fetchall()
	return data

def delete_data(task):
	c.execute('DELETE FROM taskstable WHERE task="{}"'.format(task))
	conn.commit()

"""

