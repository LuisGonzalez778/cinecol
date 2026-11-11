/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package objetos;

/**
 *
 * @author gonza
 */
public class Silla {
    private int id;
    private String codigo;
 
    public Silla(int id, String codigo) {
        this.id = id;
        this.codigo = codigo;
    }
 
    public int getId() { 
        return id; 
    }
 
    @Override
    public String toString() { 
        return codigo; 
    }

}
