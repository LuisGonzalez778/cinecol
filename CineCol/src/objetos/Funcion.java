/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package objetos;

/**
 *
 * @author gonza
 */
public class Funcion {
    private int id;
    private String descripcion;
    private double precio;
 
    public Funcion(int id, String descripcion, double precio) {
        this.id = id;
        this.descripcion = descripcion;
        this.precio = precio;
    }
 
    public int getId() { 
        return id; 
    }
    
    public double getPrecio() {
        return precio; 
    }
 
    @Override
    public String toString() { 
        return descripcion; 
    }

}
