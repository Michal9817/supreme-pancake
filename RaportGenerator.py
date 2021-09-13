import pandas as pd
import pdfkit
from datetime import datetime



path1='/home/pi/Documents/Raport.txt'
path4='/home/pi/Documents/DaneDoRaportu.txt'


df = pd.read_json(path1)
df.index += 1
df=df.rename(columns={"Data_Zrzutu": "Data Zrzutu",
                      "ID_Zrzutu": "ID Zrzutu",
                      "Współczynnik_pH": "Współczynnik pH"})

df.to_html('/home/pi/Documents/test.html',encoding='utf8')
df.to_csv('/home/pi/Documents/test.csv',encoding='utf8')
ilosc_zrzutow=df.shape[0]


#odczyt danych do raportu

with open(path4, "r",encoding='utf8') as file:
    daneRaportRAW=file.read().splitlines()
    
file.close()

#redagowanie danych do raportu

ilosc_zrzutow='{c}'.format(c=df.shape[0])
daneRaportRAW.append(ilosc_zrzutow)


config="<style type='text/css'>\
    table { page-break-inside:auto; width: 100%; }\
    tr    { page-break-inside:avoid; page-break-after:auto }\
    thead { display:table-header-group }\
    tfoot { display:table-footer-group }\
</style>"


#redagowanie danych do raportu

""" Wzór raportu:

{Nazwa zakładu}

Raport dla okresu od {OD} do {DO},
dla dostawcy: {Dostawca}.

Podsumowanie:

Ilość ścieków w okresie rozliczeniowym: {ilość ścieków},

Całkowita ilość zrzutów: {ilość zrzutów}


"""

tekst="<font size='+1'><br> Związek Międzygminny 'Nidzica'\
<br>28-500 Kazimierza  Wielka\
<br>ul. Zielona 12, tel. (041) 3521-801\
<br>\
<br></font>\
<hr>\
<br><font size='+2'>Raport dla okresu od <b>{OD}</b> do <b>{DO}</b>,\
<br>dla dostawcy: <b>{Dostawca}</b></font>.\
<br>\
<br>\
<br>\
<br><font size='+3'>Podsumowanie:</font>\
<br>\
<br><font size='+2'>Ilość ścieków w okresie rozliczeniowym: <b>{iloscS} dm<sup>3</sup></b>,\
<br>Całkowita ilość zrzutów: <b>{iloscZ}</b>.</font>\
<br>\
<br>\
<br>\
<br>\
".format(OD=daneRaportRAW[0],
         DO=daneRaportRAW[1],
         Dostawca=daneRaportRAW[2],
         iloscS=daneRaportRAW[3],
         iloscZ=daneRaportRAW[5])


with open('/home/pi/Documents/test.html', "r",encoding='utf8') as file:
    raport=file.read().splitlines()
file.close()


#zapis do html
daneALL=[config]+[tekst]+raport

with open('/home/pi/Documents/final.html', 'w', encoding='utf8') as h:
    for item in daneALL:
        h.write("%s\n" % item)
h.close()


#konwersja html do pdf

pdfkit_options = {
    'encoding': 'UTF-8'
}


now = datetime.now()

dt_string = now.strftime("%d-%m-%Y %H-%M-%S")

dest='/home/pi/Documents/RAPORTY/Raport {c}.pdf'.format(c=dt_string)

pdfkit.from_file('/home/pi/Documents/final.html', dest, options=pdfkit_options)

pdfkit.from_file('/home/pi/Documents/final.html', '/home/pi/Documents/RAPORTY/RaportTMP.pdf', options=pdfkit_options)
