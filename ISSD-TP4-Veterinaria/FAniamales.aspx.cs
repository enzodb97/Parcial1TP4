using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISSD_TP4_Veterinaria
{
    public partial class FAnimales : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // ==============================
        // MÉTODO PARA ESCRIBIR LOG
        // ==============================
        private void EscribirLog(string operacion, string tabla)
        {
            string rutaLog = Server.MapPath("~/log.txt");
            string texto = $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} - {operacion} en {tabla}";
            File.AppendAllText(rutaLog, texto + Environment.NewLine);
        }

        // ==============================
        // MÉTODO PARA MOSTRAR TOAST
        // ==============================
        private void MostrarToast(string mensaje)
        {
            string script = $"mostrarToast('{mensaje.Replace("'", "\\'")}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "toast", script, true);
        }

        // ==============================
        // BOTÓN AGREGAR ANIMAL
        // ==============================
        protected void btnAgregarAnimal_Click(object sender, EventArgs e)
        {
            try
            {
                string nombre = txtNombreAnimal.Text.Trim();
                int especie = Convert.ToInt32(ddlEspecieAnimal.SelectedValue);

                if (string.IsNullOrEmpty(nombre))
                {
                    MostrarToast("Por favor ingrese un nombre para el animal");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["VeterinariaConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "INSERT INTO Animales (nombre, especie) VALUES (@nombre, @especie)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@nombre", nombre);
                    cmd.Parameters.AddWithValue("@especie", especie);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                EscribirLog("INSERT", "Animales");
                gvAnimales.DataBind();

                txtNombreAnimal.Text = "";
                ddlEspecieAnimal.SelectedIndex = 0;

                MostrarToast($"Animal '{nombre}' agregado exitosamente");
            }
            catch (Exception ex)
            {
                MostrarToast($"Error al agregar animal: {ex.Message}");
            }
        }

        // ==============================
        // BOTÓN VER DETALLE ANIMAL
        // ==============================
        protected void btnVer_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                try
                {
                    int idAnimal = Convert.ToInt32(e.CommandArgument);
                    string connStr = ConfigurationManager.ConnectionStrings["VeterinariaConnectionString"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string query = "SELECT id, nombre, especie FROM Animales WHERE id = @id";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@id", idAnimal);

                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.Read())
                        {
                            string nombre = reader["nombre"].ToString();
                            int especie = Convert.ToInt32(reader["especie"]);
                            string especieTexto = especie == 1 ? "Perro" : especie == 2 ? "Gato" : "Ave";

                            string mensaje = $"<strong>Animal ID: {idAnimal}</strong><br/>" +
                                           $"Nombre: {nombre}<br/>" +
                                           $"Especie: {especieTexto}";

                            MostrarToast(mensaje);
                        }

                        reader.Close();
                        conn.Close();
                    }
                }
                catch (Exception ex)
                {
                    MostrarToast($"Error al obtener detalles: {ex.Message}");
                }
            }
        }

        // ==============================
        // BOTÓN AGREGAR EVENTO
        // ==============================
        protected void btnAgregarEvento_Click(object sender, EventArgs e)
        {
            try
            {
                string descripcion = txtDescripcionEvento.Text.Trim();

                if (string.IsNullOrEmpty(descripcion))
                {
                    MostrarToast("Por favor ingrese una descripción");
                    return;
                }

                int escala;
                if (!int.TryParse(txtEscalaEvento.Text, out escala))
                {
                    MostrarToast("Por favor ingrese una escala válida");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["VeterinariaConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "INSERT INTO Eventos (descripcion, escala) VALUES (@descripcion, @escala)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@descripcion", descripcion);
                    cmd.Parameters.AddWithValue("@escala", escala);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                EscribirLog("INSERT", "Eventos");
                gvEventos.DataBind();

                txtDescripcionEvento.Text = "";
                txtEscalaEvento.Text = "";

                MostrarToast("Evento agregado exitosamente");
            }
            catch (Exception ex)
            {
                MostrarToast($"Error al agregar evento: {ex.Message}");
            }
        }

        // ==============================
        // BOTÓN AGREGAR HISTORIA CLÍNICA
        // ==============================
        protected void btnAgregarHistoria_Click(object sender, EventArgs e)
        {
            try
            {
                DateTime fecha;
                if (!DateTime.TryParse(txtFechaHistoria.Text, out fecha))
                {
                    MostrarToast("Por favor ingrese una fecha válida");
                    return;
                }

                int idAnimal;
                if (!int.TryParse(txtIdAnimalHistoria.Text, out idAnimal))
                {
                    MostrarToast("Por favor ingrese un ID de animal válido");
                    return;
                }

                int idEvento;
                if (!int.TryParse(txtIdEventoHistoria.Text, out idEvento))
                {
                    MostrarToast("Por favor ingrese un ID de evento válido");
                    return;
                }

                string comentario = txtComentarioHistoria.Text.Trim();

                string connStr = ConfigurationManager.ConnectionStrings["VeterinariaConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "INSERT INTO HistoriaClinica (fecha, idAnimal, idEvento, comentario) " +
                                 "VALUES (@fecha, @idAnimal, @idEvento, @comentario)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@fecha", fecha);
                    cmd.Parameters.AddWithValue("@idAnimal", idAnimal);
                    cmd.Parameters.AddWithValue("@idEvento", idEvento);
                    cmd.Parameters.AddWithValue("@comentario", comentario);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }

                EscribirLog("INSERT", "HistoriaClinica");
                gvHistoria.DataBind();

                txtFechaHistoria.Text = "";
                txtIdAnimalHistoria.Text = "";
                txtIdEventoHistoria.Text = "";
                txtComentarioHistoria.Text = "";

                MostrarToast("Historia clínica agregada exitosamente");
            }
            catch (Exception ex)
            {
                MostrarToast($"Error al agregar historia: {ex.Message}");
            }
        }

        // ==============================
        // EVENTOS DE ANIMALES
        // ==============================
        protected void SqlDataSourceAnimales_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("INSERT", "Animales");
        }

        protected void SqlDataSourceAnimales_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("UPDATE", "Animales");
        }

        protected void SqlDataSourceAnimales_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("DELETE", "Animales");
        }

        // ==============================
        // EVENTOS DE EVENTOS
        // ==============================
        protected void SqlDataSourceEventos_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("INSERT", "Eventos");
        }

        protected void SqlDataSourceEventos_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("UPDATE", "Eventos");
        }

        protected void SqlDataSourceEventos_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("DELETE", "Eventos");
        }

        // ==============================
        // EVENTOS DE HISTORIA CLINICA
        // ==============================
        protected void SqlDataSourceHistoria_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("INSERT", "HistoriaClinica");
        }

        protected void SqlDataSourceHistoria_Updated(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("UPDATE", "HistoriaClinica");
        }

        protected void SqlDataSourceHistoria_Deleted(object sender, SqlDataSourceStatusEventArgs e)
        {
            EscribirLog("DELETE", "HistoriaClinica");
        }
    }
}