import streamlit as st

st.set_page_config(page_title='Educacion Especial', page_icon='📔')

from PIL import Image
from datetime import datetime
import pandas as pd
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


def main():
    
    stc.html(HTML_BANNER)
    
    menu = ["Crear", "Consultar", "Actualizar", "Borrar", "About"]
    choice = st.sidebar.selectbox("Menu", menu)
    #create_table()

    if choice == "Crear":
        st.subheader("CREAR INSPECCION")
        col1, col2, col3 = st.columns(3)

        with col1:
                st.text("INGRESE INFORMACION >>>")
                image = Image.open('logo.jpg')
                st.image("logo.jpg", use_column_width="always")
                with st.expander("Fuente Img"):
                    stc.html('''<a href='https://www.freepik.es/vectores/lapiz-animado'>Vector de lapiz animado creado por catalyststuff - www.freepik.es</a>''')

        with col2:
            lista_unidades = [i[0] for i in view_all_unidades()]
            unidadraw = st.selectbox("Unidad", lista_unidades).split('-')
            unidad = int(unidadraw[0])
            dia = st.date_input("Fecha Inspeccion") 
            hora = st.time_input("Hora Inspeccion")
            fecha = str(dia) + " " + str(hora) 
            
        with col3:
            obs = st.text_area("Observacion")
            lista_prioridades = [i[0] for i in view_all_prioridades()]
            prioridadraw = st.selectbox("Prioridad", lista_prioridades).split('-')
            prioridad = int(prioridadraw[0])
            apoyo = st.checkbox('Apoyo Profesional')
            if apoyo:
                apoyo = 1
                lista_apoyo=[i[0] for i in view_all_apoyo()]
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

            
    elif choice == "Consultar":
        st.subheader("CONSULTAR INSPECCION")
        with st.expander("Vista Inspecciones Detalladas"):
            result = view_all_insp()
            st.write(result)
            clean_df = pd.DataFrame(result) #, columns=["InspeccionId", "UnidadId", "Fecha", "Observacion"])
            st.dataframe(clean_df)

        with st.expander("Vista Inspecciones Cabecera"):
            result = view_all_insp_cab()
            st.write(result)
            clean_df = pd.DataFrame(result, columns=["InspeccionId","UnidadId","Nombre_Unidad","InspeccionDate","Observacion","Prioridad","Apoyo"])
            st.dataframe(clean_df)

        with st.expander("Grafica Inspecciones a Unidades"):
            uinsp_df = clean_df['Nombre_Unidad'].value_counts().to_frame()
            # st.dataframe(uinsp_df)
            uinsp_df = uinsp_df.reset_index()
            #st.dataframe(uinsp_df)

            p1 = px.pie(uinsp_df, names='index', values='Nombre_Unidad')
            st.plotly_chart(p1, use_container_width=True)


    elif choice == "Actualizar":
        st.subheader("ACTUALIZAR INSPECCION")
        
    elif choice == "Borrar":
        st.subheader("BORRAR INSPECCION")
        
    else:
        st.subheader("ACERCA DE *Educacion_Especial_App*")
        st.info("Built with Streamlit - Año 2022")
        
if __name__ == '__main__':
    main()
