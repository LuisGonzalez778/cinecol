/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JInternalFrame.java to edit this template
 */
package formulariosInternos;

import formularios.FrmPrincipal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import javax.swing.JOptionPane;
import objetos.Funcion;
import objetos.InfoConexion;
import objetos.Silla;

/**
 *
 * @author gonza
 */
public class IFrmRegistrarVenta extends javax.swing.JInternalFrame {

    /**
     * Creates new form IFrmRegistrarVenta
     */
    FrmPrincipal principal;
    InfoConexion con;
    boolean cargando = false;
    
    public IFrmRegistrarVenta(FrmPrincipal principal) {
        initComponents();
        lblPrecio.setText("");
        this.principal = principal;
        con = new InfoConexion();
        cargarFunciones();
        javax.swing.SwingUtilities.invokeLater(() -> verificarFunciones());
    }
    
    private void verificarFunciones() {
        boolean hayFunciones = comboFunciones.getItemCount() > 0;
        btnVender.setEnabled(hayFunciones);

        if (!hayFunciones) {
            JOptionPane.showMessageDialog(this,
                    "No hay funciones disponibles en este momento.");
        }
    }
    
    private void cargarSillas() {
        comboSillas.removeAllItems();
        Funcion f = (Funcion) comboFunciones.getSelectedItem();
        if (f == null) {
            lblPrecio.setText("");
            return;
        }
        lblPrecio.setText(NumberFormat
                .getCurrencyInstance(new Locale("es", "CO"))
                .format(f.getPrecio()));
 
        try (Connection conexion = DriverManager.getConnection(
                con.getUrl(), con.getUsername(), con.getPassword());
             CallableStatement cs =
                conexion.prepareCall("{call MostrarSillasDisponibles(?)}")) {
 
            cs.setInt(1, f.getId());
            try (ResultSet rs = cs.executeQuery()) {
                while (rs.next()) {
                    comboSillas.addItem(new Silla(
                            rs.getInt("id_silla"), rs.getString("codigo")));
                }
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(rootPane, e.toString());
        }
    }

    
    private void cargarFunciones() {
        cargando = true;
        try (Connection conexion = DriverManager.getConnection(
                con.getUrl(), con.getUsername(), con.getPassword());
             CallableStatement cs = conexion.prepareCall("{call MostrarFunciones()}");
             ResultSet rs = cs.executeQuery()) {
 
            SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
            comboFunciones.removeAllItems();
 
            while (rs.next()) {
                String desc = rs.getString("pelicula") + " - "
                        + rs.getString("sala") + " - "
                        + fmt.format(rs.getTimestamp("fecha_hora"))
                        + " (" + rs.getInt("libres") + " libres)";
                comboFunciones.addItem(new Funcion(
                        rs.getInt("id_funcion"), desc, rs.getDouble("precio")));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(rootPane, e.toString());
        } finally {
            cargando = false;
        }
        cargarSillas();
    }
    
    
    private void vender() {
        Funcion f = (Funcion) comboFunciones.getSelectedItem();
        Silla s = (Silla) comboSillas.getSelectedItem();
 
        if (f == null) {
            JOptionPane.showMessageDialog(this, "Selecciona una función");
            return;
        }
        if (s == null) {
            JOptionPane.showMessageDialog(this,
                    "No hay sillas disponibles para esta función");
            return;
        }
 
        try (Connection conexion = DriverManager.getConnection(
                con.getUrl(), con.getUsername(), con.getPassword());
             CallableStatement cs = conexion.prepareCall("{call GuardarVenta(?,?,?)}")) {
 
            cs.setInt(1, f.getId());
            cs.setInt(2, s.getId());
            cs.setInt(3, principal.getIdUser());
            cs.executeUpdate();
 
            JOptionPane.showMessageDialog(this, "Venta registrada con éxito");
            cargarFunciones();
            verificarFunciones();
 
        } catch (SQLIntegrityConstraintViolationException e) {
            JOptionPane.showMessageDialog(this,
                    "Esa silla ya fue vendida. Se actualizó la lista.");
            cargarFunciones();
            verificarFunciones();
            
        } catch (SQLException e) {
            if ("45000".equals(e.getSQLState())) {
                JOptionPane.showMessageDialog(this, e.getMessage());
            } else {
                JOptionPane.showMessageDialog(rootPane, e.toString());
            }
        }
    }


    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        comboFunciones = new javax.swing.JComboBox<>();
        jLabel2 = new javax.swing.JLabel();
        lblPrecio = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        comboSillas = new javax.swing.JComboBox<>();
        btnVender = new javax.swing.JButton();

        setClosable(true);

        jLabel1.setText("Función:");

        comboFunciones.setModel(new javax.swing.DefaultComboBoxModel<objetos.Funcion>());
        comboFunciones.addActionListener(this::comboFuncionesActionPerformed);

        jLabel2.setText("Precio:");

        lblPrecio.setText("jLabel3");

        jLabel3.setText("Silla:");

        comboSillas.setModel(new javax.swing.DefaultComboBoxModel<objetos.Silla>());

        btnVender.setText("Vender");
        btnVender.addActionListener(this::btnVenderActionPerformed);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(47, 47, 47)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3)
                    .addComponent(jLabel2)
                    .addComponent(jLabel1)
                    .addComponent(comboSillas, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(comboFunciones, javax.swing.GroupLayout.PREFERRED_SIZE, 380, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(lblPrecio))
                .addContainerGap(36, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(btnVender)
                .addGap(187, 187, 187))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(20, 20, 20)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(comboFunciones, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(lblPrecio)
                .addGap(26, 26, 26)
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(comboSillas, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(btnVender)
                .addContainerGap(19, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void comboFuncionesActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_comboFuncionesActionPerformed
        // TODO add your handling code here:
        if (!cargando) {
            cargarSillas();
        }

    }//GEN-LAST:event_comboFuncionesActionPerformed

    private void btnVenderActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnVenderActionPerformed
        // TODO add your handling code here:
        vender();
    }//GEN-LAST:event_btnVenderActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnVender;
    private javax.swing.JComboBox<objetos.Funcion> comboFunciones;
    private javax.swing.JComboBox<objetos.Silla> comboSillas;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel lblPrecio;
    // End of variables declaration//GEN-END:variables
}
