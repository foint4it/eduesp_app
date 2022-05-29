import streamlit as st

st.set_page_config(page_title='Educacion Especial', page_icon='📔')

from PIL import Image
from datetime import datetime as dt
import pandas as pd
from st_aggrid import AgGrid
from st_aggrid.grid_options_builder import GridOptionsBuilder
from st_aggrid.shared import GridUpdateMode


from db_fxns import * 
import streamlit.components.v1 as stc

# Data Viz Pkgs
import plotly.express as px
import matplotlib.pyplot as plt
import matplotlib

matplotlib.use('Agg')


HTML_BANNER = """
    <div style="background-color:#464e5f;padding:10px;border-radius:10px">
    <h1 style="color:white;text-align:center;">EDUCACION ESPECIAL</h1>
    <p style="color:white;text-align:center;">[Escuelas Primarias CABA]</p>
    </div>
    """
HTML_SEPARADOR = """
    <div style="background-color:#464e5f;padding:5px;border-radius:20px">
    </div>
    """
HTML_SEP = """<hr width=100%  align="center"  size=10 color="blue">"""

@st.cache
def convert_df(df):
    return df.to_csv().encode('utf-8')


def main():
    
    stc.html(HTML_BANNER)
    
    menu = ["Inspecciones", "Unidades Educacion Especial", "Escuelas", "Personal Educacion Especial", "Analitica","Exportacion Inspecciones a CSV", "About"]
    choice = st.sidebar.selectbox("MENU EDUCACION ESPECIAL", menu)
    #create_table()

    if choice == "Inspecciones":
        st.subheader("Cargar INSPECCION")
        col1, col2, col3 = st.columns(3)

        with col1:
                st.text("INGRESE INFORMACION >>>")
                image = Image.open('logo.jpg')
                st.image("logo.jpg", use_column_width="always")
                with st.expander("Fuente Img"):
                    stc.html('''<a href='https://www.freepik.es/vectores/lapiz-animado'>Vector de lapiz animado creado por catalyststuff - www.freepik.es</a>''')

        with col2:
            lista_unidades = [i[0] for i in pl_unidad()]
            unidadraw = st.selectbox("Unidad", lista_unidades).split('-')
            unidad = int(unidadraw[0])
            dia = st.date_input("Fecha Inspeccion") 
            hora = st.time_input("Hora Inspeccion")
            fecha = str(dia) + " " + str(hora) 
            
        with col3:
            obs = st.text_area("Observacion")
            lista_prioridades = [i[0] for i in pl_prioridad()]
            prioridadraw = st.selectbox("Prioridad", lista_prioridades).split('-')
            prioridad = int(prioridadraw[0])
            apoyo = st.checkbox('Apoyo Profesional')
            if apoyo:
                apoyo = 1
                lista_apoyo=[i[0] for i in pl_apoyo()]
                apoyo_det = st.multiselect("Profesionales Apoyo", lista_apoyo)
            else:
                apoyo = 0

            if st.button("Confirmar"):
                inspraw= add_insp_cab(unidad,fecha,obs,prioridad,apoyo)
                #print(inspraw)
                insp=int(inspraw[0])
                #print(insp)
                if apoyo == 1:
                    for i in range(len(apoyo_det)):
                        #print(apoyo_det[i])
                        apyraw=apoyo_det[i].split('-')
                        apy=int(apyraw[0])
                        #print(apy)
                        add_insp_det(insp,apy)
                else:
                    add_insp_det(insp,0)
                #st.info("El dato devuelto es: {}".format(type(inspraw)))
                st.success("Se agregò Inspeccion Nro {}".format(insp))

        #stc.html(HTML_SEPARADOR)

        st.subheader("Consultar INSPECCION")
        with st.expander("Vista Inspecciones Cabecera"):
            result = view_all_insp_cab()
            #st.write(result)
            clean_df = pd.DataFrame(result, columns=["InspeccionId","UnidadId","NombreUnidad","InspeccionDate","Observacion","Prioridad","Apoyo"])
            #st.dataframe(clean_df)
            #AgGrid(clean_df)

            gb = GridOptionsBuilder.from_dataframe(clean_df)
            gb.configure_selection(selection_mode="multiple", use_checkbox=True)
            gb.configure_pagination()
            gb.configure_side_bar()
            gb.configure_default_column(groupable=True, value=True, enableRowGroup=True, aggFunc="count", editable=True)
            gridOptions = gb.build()

            data = AgGrid(clean_df, 
                gridOptions=gridOptions, 
                enable_enterprise_modules=True, 
                allow_unsafe_jscode=True, 
                update_mode=GridUpdateMode.SELECTION_CHANGED)


            #grid_response= AgGrid(clean_df, gridOptions=gridOptions, enable_enterprise_modules=True)

            st.write(data)

            #df = grid_response['data']

            selected_rows = data["selected_rows"]
            selected_rows = pd.DataFrame(selected_rows)

            if len(selected_rows) != 0:
                fig = px.bar(selected_rows, "NombreUnidad", color="Apoyo")
                st.plotly_chart(fig)


    elif choice == "Escuelas":
        st.subheader("Cargar Escuelas Educacion Especial")
        with st.form("c_eee", clear_on_submit=True):
            st.write("Ingrese Datos >>>")
            nombre = st.text_input("Nombre", max_chars=200, placeholder="Ingrese Escuela")
            
            lista_dist = [i[0] for i in pl_distrito()]
            distraw = st.selectbox("Distrito", lista_dist).split('-')
            dist = int(distraw[0])

            lista_cond = [i[0] for i in pl_conduccion()]
            condraw = st.selectbox("Conduccion", lista_cond).split('-')
            conduccion = int(condraw[0])

            domicilio = st.text_input("Domicilio", max_chars=70, placeholder="Ingrese Domicilio")
            ciudad = st.text_input("Ciudad", max_chars=40, placeholder="Ingrese Ciudad")
            cpostal = st.text_input("Codigo Postal", max_chars=10, placeholder="Ingrese Codigo Postal")

            tel = st.text_input("Telefono", max_chars=24, placeholder="Ingrese Telefono")
            email = st.text_input("Email", max_chars=40, placeholder="Ingrese Email")
            
            geo = st.text_input("Geo Coordenadas", max_chars=24, placeholder="Ingrese Geo Coordenadas")

            escesp = st.checkbox('Educacion Especial')
            if escesp:
                escesp = 1
            else:
                escesp = 0
            
            # Every form must have a submit button.
            submitted = st.form_submit_button("Confirmar")
            if submitted:
                add_eee(nombre, dist, conduccion, domicilio, ciudad, cpostal, tel, email, geo, escesp)
                
                #st.info("El dato devuelto es: {}".format(type(inspraw)))
                st.success("Se agregò el establecimiento: {}".format(nombre))

        #st.write("Fuera del Form")
        st.subheader("Consultar Escuelas EE")
        
        with st.expander("Ver Escuelas Educacion Especial"):
            result = view_all_escuelas()
            #st.write(result)
            clean_df = pd.DataFrame(result,
            columns=["EscuelaId","Nombre","DistritoId","Distrito","AutoridadId","Autoridad","Domicilio","Telefono","Email","LocationGeo","EduEspecial"]) 
            #st.dataframe(clean_df)
            AgGrid(clean_df)

    elif choice == "Unidades Educacion Especial":
        st.subheader("Crear UEE")
        with st.form("c_uee", clear_on_submit=True):
            st.write("Ingrese Datos >>>")
            lista_escuelas = [i[0] for i in pl_escuela()]
            escuelaraw = st.selectbox("Escuela", lista_escuelas).split('-')
            escuela = int(escuelaraw[0])

            lista_conduccion = [i[0] for i in pl_conduccion()]
            conduccionraw = st.selectbox("Conduccion UEE", lista_conduccion).split('-')
            conduccion = int(conduccionraw[0])

            periodo = st.text_input("Periodo", max_chars=10, placeholder="Ej. Año 2022")
            descripcion = st.text_input("Descripcion", max_chars=40, placeholder="Ej. Esc.20-Mañana-C1-2022")

            col1, col2 = st.columns(2)

            with col1:
                lista_turnos = [i[0] for i in pl_turno()]
                #turnoraw = st.selectbox("Turno", lista_turnos).split('-')
                turnoraw = st.radio("Turno", lista_turnos).split('-')
                turno = int(turnoraw[0])

            with col2:
                lista_ciclos = [i[0] for i in pl_ciclo()]
                #cicloraw = st.selectbox("Ciclo", lista_ciclos).split('-')
                cicloraw = st.radio("Ciclo", lista_ciclos).split('-')
                ciclo = int(cicloraw[0])

            lista_doc_esp=[i[0] for i in pl_doc_esp()]
            doc_esp_det = st.multiselect("Docentes Educacion Especial", lista_doc_esp)
                                    
            # Every form must have a submit button.
            submitted = st.form_submit_button("Confirmar")
            if submitted:
                ueeraw= add_uee_cab(escuela,turno,ciclo,conduccion,periodo,descripcion)
                #print(inspraw)
                unidad=int(ueeraw[0])
                for i in range(len(doc_esp_det)):
                    #print(doc_esp_det[i])
                    doc_espraw=doc_esp_det[i].split('-')
                    doc_esp=int(doc_espraw[0])
                    #print(doc_esp)
                    add_uee_det(unidad,doc_esp)
                
                #st.info("El dato devuelto es: {}".format(type(inspraw)))
                st.success("Se agregò UEE Nro {}".format(unidad))


        st.write("Outside the form")
        st.subheader("Consultar UEE")
        with st.expander("Ver Unidades Educacion Especial"):
            result = view_all_uee()
            #st.write(result)
            clean_df = pd.DataFrame(result, 
            columns=["UnidadId","Periodo","Descripcion","Escuela","ConduccionId","Apellido","Nombre","Conduccion","Turno","Ciclo","LineDet","DocenteId","NombreCompleto"])
            #st.dataframe(clean_df)
            AgGrid(clean_df)

    elif choice == "Personal Educacion Especial":
        st.subheader("Cargar Personal EE (Docentes, Apoyos y Directivos)")
        with st.form("c_pee", clear_on_submit=True):
            st.write("Ingrese Datos >>>")
            apellido = st.text_input("Apellido", max_chars=20, placeholder="Ingrese Apellido")
            nombre = st.text_input("Nombre", max_chars=20, placeholder="Ingrese Nombre")
            
            lista_cat = [i[0] for i in pl_cat()]
            catraw = st.selectbox("Categoria", lista_cat).split('-')
            cat = int(catraw[0])

            lista_funcion = [i[0] for i in pl_funcion()]
            funcionraw = st.selectbox("Funcion", lista_funcion).split('-')
            funcion = int(funcionraw[0])

            telefono = st.text_input("Telefono", max_chars=24, placeholder="Ingrese Telefono")
            email = st.text_input("Email", max_chars=60, placeholder="Ingrese Email")
            
            docesp = st.checkbox('Docente Especial')
            if docesp:
                docesp = 1
            else:
                docesp = 0

            conduccion = st.checkbox('Conduccion')
            if conduccion:
                conduccion = 1
            else:
                conduccion = 0

            apoyo = st.checkbox('Apoyo')
            if apoyo:
                apoyo = 1
            else:
                apoyo = 0

            # Every form must have a submit button.
            submitted = st.form_submit_button("Confirmar")
            if submitted:
                add_pee(apellido, nombre, cat, funcion, telefono, email, docesp, conduccion, apoyo)
                
                #st.info("El dato devuelto es: {}".format(type(inspraw)))
                st.success("Se agregò a {}, {}".format(apellido,nombre))

        #st.write("Fuera del Form")
        st.subheader("Consultar Personal EE")
        
        with st.expander("Ver Docentes Educacion Especial"):
            result = view_all_docesp()
            #st.write(result)
            clean_df = pd.DataFrame(result, columns=["Id","Apellido","Nombre","NombreCompleto","Telefono","Email","Cat","Funcion","DocEsp","Cond","Apoyo"]) 
            #st.dataframe(clean_df)
            AgGrid(clean_df)

        with st.expander("Ver Conduccion Educacion Especial"):
            result = view_all_conduccion()
            #st.write(result)
            clean_df = pd.DataFrame(result,columns=["Id","Apellido","Nombre","NombreCompleto","Telefono","Email","Cat","Funcion","DocEsp","Cond","Apoyo"]) 
            #st.dataframe(clean_df)
            AgGrid(clean_df)

        with st.expander("Ver Apoyo Educacion Especial"):
            result = view_all_apoyo()
            #st.write(result)
            clean_df = pd.DataFrame(result,columns=["Id","Apellido","Nombre","NombreCompleto","Telefono","Email","Cat","Funcion","DocEsp","Cond","Apoyo"]) 
            #st.dataframe(clean_df)
            AgGrid(clean_df)

    elif choice == "Exportacion Inspecciones a CSV":
        st.subheader("Exportar Vista_Inspecciones_Total a CSV")
        with st.expander("Vista Inspecciones Total"):
            inspeccion_total = view_inspeccion_tot()
            #st.write(result)
            clean_df_insp_tot = pd.DataFrame(inspeccion_total,
            columns=["InspId", "UnidadId", "Unidad","FHora", "Fecha", "Obs","Prioridad","ConApoyo",
            "EscId","Escuela","Distrito","TurnoId","Turno","CicloId","Ciclo","DetId",
            "ApoyoId","NombreApoyo","CatId","Categoria","FuncionId","Funcion"])
            #st.dataframe(clean_df_insp_tot)
            #AgGrid(clean_df_insp_tot)
            
            # Data 
            gb = GridOptionsBuilder.from_dataframe(clean_df_insp_tot)
            gb.configure_pagination()
            gridOptions = gb.build()

            AgGrid(clean_df_insp_tot, gridOptions=gridOptions)
            
            

            csv = convert_df(clean_df_insp_tot)
            st.download_button(
                label="Download data as CSV",
                data=csv,
                file_name='inspecciones_totales.csv',
                mime='text/csv',
            )

        
    elif choice == "Analitica":
        st.subheader("Ingrese Parametros Filtrado DataFrame")

        with st.expander("Tabla Cruzada y Grafica"):
                insp_total = view_inspeccion_nodet()
                #st.write(result)
                df = pd.DataFrame(insp_total,
                columns=["InspId", "UnidadId", "Unidad","Fecha","FInt", "Obs","Prioridad","ConApoyo",
                "EscId","Escuela","Distrito","TurnoId","Turno","CicloId","Ciclo"])
                #df.info()
                #st.dataframe(df)
                
                df['Fecha'] = pd.to_datetime(df['Fecha'], errors='coerce').dt.date
                #df.info()
                
                dist = st.multiselect("Elija Distrito",
                options=df['Distrito'].unique(), 
                default=df['Distrito'].unique())

                escuela = st.multiselect("Elija Escuela", 
                options=df['Escuela'].unique(),
                default=df['Escuela'].unique())


                start_date = st.date_input('Fecha Inicio:')
                print(start_date)
                end_date = st.date_input('Fecha Fin:')
                #start_date, end_date = st.date_input('Elija Fecha Inicio, Fecha Final:',[])
                if end_date >= start_date:
                    pass
                else:
                    st.error('Error: Fecha Inicial debe ser menor o igual que Fecha Final')

                mask = (df['Fecha'] >= start_date) & (df['Fecha'] <= end_date) & (df['Distrito'].isin(dist)) & (df['Escuela'].isin(escuela)) 
                dffiltro = df.loc[mask]
                
                #stc.html(HTML_SEP)
                st.header('----------------------------------------------------------')
                st.text("<<Tabla Inspecciones>>")
                #st.dataframe(dffiltro)

                gb = GridOptionsBuilder.from_dataframe(dffiltro)

                gb.configure_pagination()
                gb.configure_side_bar()
                gb.configure_default_column(groupable=True, value=True, enableRowGroup=True, aggFunc="count", editable=True)
                gridOptions = gb.build()

                AgGrid(dffiltro, gridOptions=gridOptions, enable_enterprise_modules=True)

                st.header('----------------------------------------------------------')
                #stc.html(HTML_SEP)
                st.text("<<CrossTable: Cantidad de Inspecciones por Distrito/Unidad y Turno/Ciclo>>")
                dfcross= dffiltro.pivot_table('Fecha',['Distrito','Unidad'],['Turno','Ciclo'], aggfunc='count', margins=True,fill_value=0) #,dropna=False,fill_value=0)
                st.dataframe(dfcross)
                #AgGrid(dfcross)

                st.header('----------------------------------------------------------')
                #stc.html(HTML_SEP)
                st.text("<<Grafico: Cantidad de Inspecciones por Unidad>>")
                uinsp_df = dffiltro['Unidad'].value_counts().to_frame()
                #st.dataframe(uinsp_df)
                uinsp_df = uinsp_df.reset_index()
                st.dataframe(uinsp_df)

                p1 = px.pie(uinsp_df, names='index', values='Unidad')
                st.plotly_chart(p1, use_container_width=True)
    
    
                
    else:
        st.subheader("ACERCA DE *Educacion_Especial_App*")
        st.info("Built with Streamlit - Año 2022")
        
if __name__ == '__main__':
    main()
