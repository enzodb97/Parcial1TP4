<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FAnimales.aspx.cs" Inherits="ISSD_TP4_Veterinaria.FAnimales" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestión Veterinaria</title>
    <style>
        body { font-family: Arial; margin: 20px; background-color: #f5f5f5; }
        h2 { color: #333; }
        .seccion { margin-bottom: 40px; padding: 15px; background: #fff; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .btn-agregar { 
            background-color: #4CAF50; 
            color: white; 
            padding: 10px 20px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            margin: 10px 0;
            font-size: 14px;
        }
        .btn-agregar:hover { background-color: #45a049; }
        .form-agregar {
            background-color: #f9f9f9;
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        .form-agregar input, .form-agregar select {
            margin: 5px 10px 5px 0;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-agregar label {
            display: inline-block;
            width: 100px;
            font-weight: bold;
        }
        .toast {
            visibility: hidden;
            min-width: 250px;
            background-color: #333;
            color: #fff;
            text-align: center;
            border-radius: 4px;
            padding: 16px;
            position: fixed;
            z-index: 1000;
            left: 50%;
            top: 30px;
            transform: translateX(-50%);
            font-size: 14px;
        }
        .toast.show {
            visibility: visible;
            animation: fadein 0.5s, fadeout 0.5s 2.5s;
        }
        @keyframes fadein {
            from {top: 0; opacity: 0;}
            to {top: 30px; opacity: 1;}
        }
        @keyframes fadeout {
            from {top: 30px; opacity: 1;}
            to {top: 0; opacity: 0;}
        }
    </style>
    <script type="text/javascript">
        function mostrarToast(mensaje) {
            var toast = document.getElementById("toast");
            toast.innerHTML = mensaje;
            toast.className = "toast show";
            setTimeout(function () { toast.className = toast.className.replace("show", ""); }, 3000);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- Toast para mensajes -->
            <div id="toast" class="toast"></div>

            <!-- ============================= -->
            <!-- SECCION ANIMALES -->
            <!-- ============================= -->
            <div class="seccion">
                <h2>Gestión de Animales</h2>
                
                <!-- Formulario para agregar nuevo animal -->
                <div class="form-agregar">
                    <h3>Agregar Nuevo Animal</h3>
                    <div>
                        <label>Nombre:</label>
                        <asp:TextBox ID="txtNombreAnimal" runat="server" />
                    </div>
                    <div style="margin-top: 10px;">
                        <label>Especie:</label>
                        <asp:DropDownList ID="ddlEspecieAnimal" runat="server">
                            <asp:ListItem Value="1">Perro</asp:ListItem>
                            <asp:ListItem Value="2">Gato</asp:ListItem>
                            <asp:ListItem Value="3">Ave</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="btnAgregarAnimal" runat="server" Text="Agregar Animal" 
                        CssClass="btn-agregar" OnClick="btnAgregarAnimal_Click" />
                </div>

                <asp:GridView ID="gvAnimales" runat="server" AutoGenerateColumns="False" DataKeyNames="id"
                    DataSourceID="SqlDataSourceAnimales" CssClass="table" AllowPaging="true" AllowSorting="true">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="especie" HeaderText="Especie (1=Perro, 2=Gato, 3=Ave)" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:Button ID="btnVer" runat="server" Text="Ver" 
                                    CommandName="VerDetalle" CommandArgument='<%# Eval("id") %>' 
                                    OnCommand="btnVer_Command" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSourceAnimales" runat="server"
                    ConnectionString="<%$ ConnectionStrings:VeterinariaConnectionString %>"
                    SelectCommand="SELECT * FROM Animales"
                    InsertCommand="INSERT INTO Animales (nombre, especie) VALUES (@nombre, @especie)"
                    UpdateCommand="UPDATE Animales SET nombre=@nombre, especie=@especie WHERE id=@id"
                    DeleteCommand="DELETE FROM Animales WHERE id=@id"
                    OnInserted="SqlDataSourceAnimales_Inserted"
                    OnUpdated="SqlDataSourceAnimales_Updated"
                    OnDeleted="SqlDataSourceAnimales_Deleted">
                    <InsertParameters>
                        <asp:Parameter Name="nombre" Type="String" />
                        <asp:Parameter Name="especie" Type="Int32" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="nombre" Type="String" />
                        <asp:Parameter Name="especie" Type="Int32" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                </asp:SqlDataSource>
            </div>

            <!-- ============================= -->
            <!-- SECCION EVENTOS -->
            <!-- ============================= -->
            <div class="seccion">
                <h2>Gestión de Eventos</h2>
                
                <!-- Formulario para agregar nuevo evento -->
                <div class="form-agregar">
                    <h3>Agregar Nuevo Evento</h3>
                    <div>
                        <label>Descripción:</label>
                        <asp:TextBox ID="txtDescripcionEvento" runat="server" Width="300px" />
                    </div>
                    <div style="margin-top: 10px;">
                        <label>Escala:</label>
                        <asp:TextBox ID="txtEscalaEvento" runat="server" TextMode="Number" />
                    </div>
                    <asp:Button ID="btnAgregarEvento" runat="server" Text="Agregar Evento" 
                        CssClass="btn-agregar" OnClick="btnAgregarEvento_Click" />
                </div>

                <asp:GridView ID="gvEventos" runat="server" AutoGenerateColumns="False" DataKeyNames="id"
                    DataSourceID="SqlDataSourceEventos" AllowPaging="true" AllowSorting="true">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="descripcion" HeaderText="Descripción" />
                        <asp:BoundField DataField="escala" HeaderText="Escala" />
                        <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSourceEventos" runat="server"
                    ConnectionString="<%$ ConnectionStrings:VeterinariaConnectionString %>"
                    SelectCommand="SELECT * FROM Eventos"
                    InsertCommand="INSERT INTO Eventos (descripcion, escala) VALUES (@descripcion, @escala)"
                    UpdateCommand="UPDATE Eventos SET descripcion=@descripcion, escala=@escala WHERE id=@id"
                    DeleteCommand="DELETE FROM Eventos WHERE id=@id"
                    OnInserted="SqlDataSourceEventos_Inserted"
                    OnUpdated="SqlDataSourceEventos_Updated"
                    OnDeleted="SqlDataSourceEventos_Deleted">
                    <InsertParameters>
                        <asp:Parameter Name="descripcion" Type="String" />
                        <asp:Parameter Name="escala" Type="Int32" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="descripcion" Type="String" />
                        <asp:Parameter Name="escala" Type="Int32" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                </asp:SqlDataSource>
            </div>

            <!-- ============================= -->
            <!-- SECCION HISTORIA CLINICA -->
            <!-- ============================= -->
            <div class="seccion">
                <h2>Gestión de Historia Clínica</h2>
                
                <!-- Formulario para agregar nueva historia clínica -->
                <div class="form-agregar">
                    <h3>Agregar Nueva Historia Clínica</h3>
                    <div>
                        <label>Fecha:</label>
                        <asp:TextBox ID="txtFechaHistoria" runat="server" TextMode="Date" />
                    </div>
                    <div style="margin-top: 10px;">
                        <label>ID Animal:</label>
                        <asp:TextBox ID="txtIdAnimalHistoria" runat="server" TextMode="Number" />
                    </div>
                    <div style="margin-top: 10px;">
                        <label>ID Evento:</label>
                        <asp:TextBox ID="txtIdEventoHistoria" runat="server" TextMode="Number" />
                    </div>
                    <div style="margin-top: 10px;">
                        <label>Comentario:</label>
                        <asp:TextBox ID="txtComentarioHistoria" runat="server" TextMode="MultiLine" 
                            Rows="3" Width="300px" />
                    </div>
                    <asp:Button ID="btnAgregarHistoria" runat="server" Text="Agregar Historia" 
                        CssClass="btn-agregar" OnClick="btnAgregarHistoria_Click" />
                </div>

                <asp:GridView ID="gvHistoria" runat="server" AutoGenerateColumns="False" DataKeyNames="id"
                    DataSourceID="SqlDataSourceHistoria" AllowPaging="true" AllowSorting="true">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="idAnimal" HeaderText="ID Animal" />
                        <asp:BoundField DataField="idEvento" HeaderText="ID Evento" />
                        <asp:BoundField DataField="comentario" HeaderText="Comentario" />
                        <asp:CommandField ShowEditButton="true" ShowDeleteButton="true" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSourceHistoria" runat="server"
                    ConnectionString="<%$ ConnectionStrings:VeterinariaConnectionString %>"
                    SelectCommand="SELECT * FROM HistoriaClinica"
                    InsertCommand="INSERT INTO HistoriaClinica (fecha, idAnimal, idEvento, comentario) VALUES (@fecha, @idAnimal, @idEvento, @comentario)"
                    UpdateCommand="UPDATE HistoriaClinica SET fecha=@fecha, idAnimal=@idAnimal, idEvento=@idEvento, comentario=@comentario WHERE id=@id"
                    DeleteCommand="DELETE FROM HistoriaClinica WHERE id=@id"
                    OnInserted="SqlDataSourceHistoria_Inserted"
                    OnUpdated="SqlDataSourceHistoria_Updated"
                    OnDeleted="SqlDataSourceHistoria_Deleted">
                    <InsertParameters>
                        <asp:Parameter Name="fecha" Type="DateTime" />
                        <asp:Parameter Name="idAnimal" Type="Int32" />
                        <asp:Parameter Name="idEvento" Type="Int32" />
                        <asp:Parameter Name="comentario" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="fecha" Type="DateTime" />
                        <asp:Parameter Name="idAnimal" Type="Int32" />
                        <asp:Parameter Name="idEvento" Type="Int32" />
                        <asp:Parameter Name="comentario" Type="String" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                </asp:SqlDataSource>
            </div>

        </div>
    </form>
</body>
</html>