/*
Petrescu Cosmin 143
Visual Studio 2019
Bilbie Florin
*/
#include <iostream>
#include <string>
#include <vector>
#include <cmath>
using namespace std;

class Masca {
protected:
    string tipProtectie; //ffp1/ffp2/ffp3
    string culoare;
    unsigned nrPliuri;
    virtual void scrieExtra(ostream& out) const = 0;
    virtual void citesteExtra(istream& in) = 0;
    //cele doua functii virtale de mai sus sunt dupa modelul
    //facut la laborator pentru smart reading/writing 
public:
    Masca() = default;
    Masca(string, string, unsigned);
    //virtual ~Masca();
    friend istream& operator>>(istream&, Masca&);
    friend ostream& operator<<(ostream&, const Masca&);
    virtual double pret() = 0;
    //Masca(const Masca&) = default;
   // Masca operator=(const Masca&) = default;
};

Masca::Masca(string t, string c, unsigned nr) :tipProtectie(t), culoare(c), nrPliuri(nr) {}

istream& operator>>(istream& in, Masca& m) {
    in >> m.tipProtectie >> m.culoare >> m.nrPliuri;
    m.citesteExtra(in);
    return in;
}

ostream& operator<<(ostream& out, const Masca& m) {
    out << "Tip protectie: " << m.tipProtectie << endl;
    out << "Culoare: " << m.culoare << endl;
    out << "Nr Pliuri: " << m.nrPliuri << endl;
    m.scrieExtra(out);
    return out;
}

//----------------------------------------------------

class MascaChirurgicala : public Masca {
protected:
    string logo;
    virtual void scrieExtra(ostream& out)const;
    virtual void citesteExtra(istream& in);
public:
    MascaChirurgicala() :Masca() {};
    MascaChirurgicala(string t, string c, unsigned nr, string logo = "") :Masca(t, c, nr) {
        this->logo = logo;
    }
    virtual double pret();
};

double MascaChirurgicala::pret() {
    float extra;
    if (logo != "") extra = 1.5f;
    else extra = 1;
    if (tipProtectie == "ffp1") {
        return 5 * extra;
    }
    if (tipProtectie == "ffp2") {
        return 10 * extra;
    }
    if (tipProtectie == "ffp3") {
        return 15 * extra;
    }
}

void MascaChirurgicala::citesteExtra(istream& in) {
    in >> logo;
}
void MascaChirurgicala::scrieExtra(ostream& out) const {
    out << "Logo: " << logo;
}
//------------------------------------------------------------------

class MascaPolicarbonat :public Masca {
    //tipul de protectie e default ffp0
protected:
    string tipPrindere;
    virtual void scrieExtra(ostream& out)const;
    virtual void citesteExtra(istream& in);
public:
    MascaPolicarbonat() :Masca() {
        tipProtectie = "ffp0";
    }
    MascaPolicarbonat(string culoare, string prindere, unsigned nr) :Masca("ffp0", culoare, nr) {
        this->nrPliuri = nr;
    }
    virtual double pret();
};

double MascaPolicarbonat::pret() {
    return 20;
}

void MascaPolicarbonat::scrieExtra(ostream& out) const {
    out << "Tip prindere: " << tipPrindere << endl;
}

void MascaPolicarbonat::citesteExtra(istream& in) {
    in >> tipPrindere;
}
//---------------------------------------------------------------------

class Dezinfectant {
protected:
    unsigned long nrUcise;
    vector<string> ingrediente;
    vector<string> suprafete;
public:
    Dezinfectant() = default;
    Dezinfectant(unsigned nr, vector<string> i, vector<string> s) : nrUcise(nr), ingrediente(i), suprafete(s) {};
    virtual double eficienta() = 0;
    unsigned pret();
    friend istream& operator>>(istream&, Dezinfectant&);
};

istream& operator>>(istream& in, Dezinfectant& d) {
    in >> d.nrUcise;
    int a, b;
    string x;
    cout << "Nr Ingrediente: " << endl;
    in >> a;
    for (int i = 0; i < a; i++) {
        in >> x;
        d.ingrediente.push_back(x);
    }
    cout << "Nr Suprafete: " << endl;
    in >> b;
    for (int i = 0; i < b; i++) {
        in >> x;
        d.suprafete.push_back(x);
    }
    return in;
}

unsigned Dezinfectant::pret() {
    double efic = eficienta();
    if (efic < 90) {
        return 10;
    }
    if (efic < 95) {
        return 20;
    }
    if (efic < 97.5) {
        return 30;
    }
    if (efic < 99) {
        return 40;
    }
    if (efic < 99.99) {
        return 50;
    }
}

//----------------------------------------------------------------------------

class DezinfectantBacterii :public Dezinfectant {
public:
    DezinfectantBacterii() :Dezinfectant() {};
    DezinfectantBacterii(unsigned nr, vector<string> i, vector<string> s) :Dezinfectant(nr, i, s) {};
    virtual double eficienta();
};

double DezinfectantBacterii::eficienta() {
    long total = pow(10, 9);
    return nrUcise / total;
}

//----------------------------------------------------

class DezinfectantFungi :public Dezinfectant {
public:
    DezinfectantFungi() : Dezinfectant() {};
    DezinfectantFungi(unsigned nr, vector<string> i, vector<string> s) :Dezinfectant(nr, i, s) {};
    virtual double eficienta();
};
double DezinfectantFungi::eficienta() {
    double total = 1.5 * pow(10, 6);
    return nrUcise / total;
}

//--------------------------------------------------

class DezinfectantVirusi :public Dezinfectant {
public:
    DezinfectantVirusi() :Dezinfectant() {};
    DezinfectantVirusi(unsigned nr, vector<string> i, vector<string> s) :Dezinfectant(nr, i, s) {};
    virtual double eficienta();
};

double DezinfectantVirusi::eficienta() {
    long total = pow(10, 8);
    return nrUcise / total;
}

//-----------------------------------------------------

class Achizitie {
    unsigned zi, luna, an;
    string nume;
    vector<Dezinfectant*> Dezinfectanti;
    vector<Masca*>Masti;
public:
    Achizitie() = default;
    Achizitie(unsigned zi, unsigned luna, unsigned an, string nume) :zi(zi), luna(luna), an(an), nume(nume) {};
    Achizitie operator+=(Masca* m) {
        Masti.push_back(m);
        return *this;
    }
    Achizitie operator+=(Dezinfectant* d) {
        Dezinfectanti.push_back(d);
        return *this;
    }
    double total();
    //unsigned luna() { return luna; };
    friend istream& operator>>(istream&, Achizitie&);
};

double Achizitie::total() {
    double t = 0;
    for (auto d : Dezinfectanti) {
        t += d->pret();
    }
    for (auto m : Masti) {
        t += m->pret();
    }
    return t;
}

istream& operator>>(istream& in, Achizitie& a) {
    in >> a.zi >> a.luna >> a.an;
    in >> a.nume;
    return in;
}

//-------------------------------------------------------

int main()
{
    //Meniu:
    vector<Masca*> StocMasti;
    vector<Dezinfectant*> StocDezinfectanti;
    vector<Achizitie*> listAchizitii;
    bool optiune = true;
    while (optiune) {
        cout << "Introduceti comanda: " << endl;
        int tip;
        cin >> tip;
        if (tip == 1) {
            Dezinfectant* d;
            int tipDez;
            cout << "Apasati 1 pentru Dezinfectant Bacterii" << endl;
            cout << "Apasati 2 pentru Dezinfectant Fungi" << endl;
            cout << "Apasati 3 pentru Dezinfectant Virusi" << endl;
            cin >> tipDez;
            if (tipDez == 1) {
                d = new DezinfectantBacterii();
                cin >> *d;
            }
            if (tipDez == 2) {
                d = new DezinfectantFungi();
                cin >> *d;
            }
            if (tipDez == 3) {
                d = new DezinfectantVirusi();
                cin >> *d;
            }
            StocDezinfectanti.push_back(d);
        }
        if (tip == 2) {
            Masca* m;
            int tipM;
            cout << "Apasati 1 pentru Masca Chirurgicala" << endl;
            cout << "Apasati 2 pentru Masca Policarbonat" << endl;
            cin >> tipM;
            if (tipM == 1) {
                m = new MascaChirurgicala();
                cin >> *m;
            }
            if (tipM == 2) {
                m = new MascaPolicarbonat();
                cin >> *m;
            }
            StocMasti.push_back(m);
        }
        if (tip == 3) {
            cout << "Introduceti datele achizitiei: " << endl;
            Achizitie* a = NULL;
            cin >> *a;
            listAchizitii.push_back(a);
        }
        if (tip == 4) {
            double ef = 0;
            Dezinfectant* best = NULL;
            for (auto d : StocDezinfectanti) {
                if (d->eficienta() > ef) {
                    ef = d->eficienta();
                    best = d;
                }
            }
            cout << "Dezinfectantul cel mai eficient: " << endl;
            cout << best;
        }
        //if (tip == 5) {
        //    int total = 0;
        //    int l;
        //    cout << "Luna :" << endl;
        //    cin >> l;
        //    for (auto a : listAchizitii) {
        //        if (a->luna() == l) {
        //            total += a->total();
        //        }
        //    }
        //    cout << "Venit lunar: " << total;
        //}
    }
}