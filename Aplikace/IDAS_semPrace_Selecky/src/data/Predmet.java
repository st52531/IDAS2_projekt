package data;

/**
 *
 * @author Libor Selecky
 */
public class Predmet {

    private int id;
    private String zkratka;
    private String nazev;

    public Predmet(String zkratka, String nazev) {
        this.zkratka = zkratka;
        this.nazev = nazev;
    }

    public Predmet(int id, String zkratka, String nazev) {
        this.id = id;
        this.zkratka = zkratka;
        this.nazev = nazev;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getZkratka() {
        return zkratka;
    }

    public void setZkratka(String zkratka) {
        this.zkratka = zkratka;
    }

    public String getNazev() {
        return nazev;
    }

    public void setNazev(String nazev) {
        this.nazev = nazev;
    }

    @Override
    public String toString() {
        return nazev;
    }

}
