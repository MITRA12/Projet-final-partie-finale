// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'lesQuestions.dart';
import 'Question.dart';
import 'dart:async';


 AudioElement backgroung = new AudioElement("/son/Candy.ogg");
 AudioElement vrai, faux, tick ;
 AudioElement tick2 = new AudioElement("/son/Tick_Tock.wav");
 
 Element laQuestion = querySelector('#Question');
 Element reponses = querySelector('#reponses');
 List<Question> listeDesQuestions = listeQuestions();
 List<int> choixUtilisateur = new List<int>();

 ButtonElement next = querySelector('#next'); 
 ButtonElement rep1 = querySelector('#rep1');
 ButtonElement rep2 = querySelector('#rep2');
 ButtonElement rep3 = querySelector('#rep3');
 ButtonElement rep4 = querySelector('#rep4'); 
 ButtonElement tempsChrono = querySelector('#temps'); 
 
 int secondechrono = 60;
 int minutechrono =1;
 int compteur = -1;
 Timer chrono = null;

 

 
 void main() {
 
   backgroung.play();
   debuterChrono(1);
   chargerQuestions(); 
   initChoixUtil();     
   choixReponses();
   next.onClick.listen((event) => chargerQuestions());  
   tempsChrono.onClick.listen((event) => debuterChrono(2));  
   
  }
 
 void choixReponses(){       
      
      rep1.onClick.listen(clickReponse);
      rep2.onClick.listen(clickReponse);
      rep3.onClick.listen(clickReponse);
      rep4.onClick.listen(clickReponse);
 }
 
 void clickReponse (Event e){
   
   Element temp = e.target;
     
   if(temp == rep1){
     choixUtilisateur[compteur] = 1;
     rep1.focus();
   }else if(temp == rep2){
     choixUtilisateur[compteur] = 2;
     rep2.focus(); 
   }else if(temp == rep3){
     choixUtilisateur[compteur] = 3;
     rep3.focus(); 
   }else if(temp == rep4){
     choixUtilisateur[compteur] = 4;
     rep4.focus();
   }
   
 }

  
  void chargerQuestions(){
   compteur++;
   vrai = new AudioElement("/son/Correct.ogg");
   faux = new AudioElement("/son/Wrong.ogg");
   if(compteur>0){
     if(choixUtilisateur[compteur-1] == listeDesQuestions[compteur-1].bonneReponse ){
      vrai.play();
     }else{
       faux.play();
     }
   }
   if(compteur<listeDesQuestions.length){      
    
    laQuestion.text = listeDesQuestions[compteur].la_question ; // on charge  la question 
    rep1.text = listeDesQuestions[compteur].les_reponses[0];
    rep2.text = listeDesQuestions[compteur].les_reponses[1];
    rep3.text = listeDesQuestions[compteur].les_reponses[2];
    rep4.text = listeDesQuestions[compteur].les_reponses[3];
     
  }else{ afficherResultats(); }
    
  }
    
  
    void afficherResultats(){
      
      chrono.cancel();
      querySelector('#next').remove();
      querySelector('#Question').remove();
      querySelector('#reponses').remove();
      UListElement listeResultat = new UListElement();
      LIElement nouveau = new LIElement();
      listeResultat = querySelector('#result'); 
      
      print(choixUtilisateur.toString());   
      int trouvee = 0;
      for(int i =0 ; i< 10 ; ++i){
        
        String temp;
        
        
              if(choixUtilisateur[i] == listeDesQuestions[i].bonneReponse ){  
                trouvee++;      
                temp = listeDesQuestions[i].la_question;
                nouveau.text = "$temp : Bonne réponse";               
                listeResultat.children.add(nouveau);
              }else if(choixUtilisateur[i] == 999){
                temp = listeDesQuestions[i].la_question;
                nouveau.text = "$temp: Aucune réponse";
                listeResultat.children.add(nouveau); 
              }else{
                temp = listeDesQuestions[i].la_question;
                nouveau.text = "$temp: Mauvaise réponse";
                listeResultat.children.add(nouveau);               
              }
              nouveau = new LIElement();
            }
      
      querySelector('#score').text = " Votre Scrore : $trouvee / 10  " ;
    }
    
    void initChoixUtil(){
      
      for(int i =0 ; i< 10 ; ++i){
        choixUtilisateur.add(999);
      }
    }
    
    
    void debuterChrono(int a) {      
       
      var oneSecond = new Duration(seconds:1);     
        
        if(a == 2){ 
          if(chrono.isActive){ 
            chrono.cancel(); tempsChrono.focus();  next.hidden = true;
           
          }else{
            chrono = new Timer.periodic(oneSecond, handleTimeout); 
            tempsChrono.blur();
            next.hidden = false;            
          }
          
        }else{
          chrono = new Timer.periodic(oneSecond, handleTimeout); 
        }
      
      
    }
   
    void handleTimeout( Timer _) {  // callback function
      tick = new AudioElement("/son/Tick.ogg");
      
      if(minutechrono > 0 && secondechrono ==0){
              minutechrono-- ; secondechrono+=60;
            }
      
      if (secondechrono>0){
        secondechrono--; tick.play();
      }else if(secondechrono == 0){
        afficherResultats();
        _.cancel(); 
      }
      
      
      if(secondechrono<10){
        querySelector('#temps').text = "0$minutechrono : 0$secondechrono";
      }else{
        querySelector('#temps').text = "0$minutechrono : $secondechrono";
      }
      
      if(secondechrono < 10 && minutechrono == 0){
           tick2.play();
         }
    }
    
 
  
