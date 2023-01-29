
choice=input("1 For encoder, 2 for decoder");
if(choice==1)
    dtmfEncoder()

elseif(choice==2)
    dtmfDecoder()
end


function [dtmfSignals]= dtmfEncoder()
    emptyArray=zeros(1,1000);
    Fs = 8000;
    T=1/Fs*(1:Fs/8); % 8 arttıkça sesler daha uzun süre duyulur.

    amplitude = 0.5;
    phoneNumber = input("Number to be encoded: ",'s');
    lowFreqs = [697 770 852 941];
    highFreqs = [1209 1336 1477 1633];
   
    digitSignals=[];
    dtmfSignals=[];
    for i = 1:length(phoneNumber)

        if phoneNumber(i) == '0'
          digitSignals = sin(2*pi*lowFreqs(4)*T) +  sin(2*pi*highFreqs(2)*T);
        
        else
            currLowFreq=floor((phoneNumber(i)-'0'-1)/3)+1;
            currHighFreq=mod(phoneNumber(i)-'0'-1,3)+1; %%determine the high freq
            digitSignals = sin(2*pi*lowFreqs(currLowFreq)*T) + sin(2*pi*highFreqs(currHighFreq)*T);
        end
       digitSignals= [digitSignals,emptyArray];
       dtmfSignals = [dtmfSignals digitSignals];
    end
    
    dtmfSignals=dtmfSignals*amplitude;
    audiowrite('phoneNumber.wav',dtmfSignals,Fs);
end



function []= dtmfDecoder()
% BU FONKSIYONDA N=11 KABUL EDİLMİŞTİR EĞER  DEĞİŞKEN BİR N ALINACAKSA
% İLGİLİ SATIR INPUT İLE DEĞİŞTİRİLEBİLİR
    newChoice= input("Eger odevde verilen numarayi decode etmek istiyorsaniz 1\n en son encode edilen numarayı decode etmek istiyor iseniz 2yi tuslayiniz: ");
    if(newChoice==1)
        [tel,fs] = audioread('Ornek.wav');
        
    elseif(newChoice==2)
        [tel,fs] = audioread('phoneNumber.wav'); 

    end


    BIGT = 1/fs;
    tel = tel(:,1); 
    t = 0:BIGT:(length(tel)*BIGT) - BIGT;
    n = 11;  
    d = floor(length(tel)/n);
    numpad = ['1','2','3';'4','5','6';'7','8','9';'*','0','#']; 
    
    %stem(t,tel); title('Verilen .wav dosyasinin ayrik zamanda cizimi'); xlabel('zaman(t)'); ylabel('Genlik');
    %plot(t,tel); title('Verilen .wav dosyasinin surekli cizimi'); xlabel('zaman(t)'); ylabel('Genlik');
    for k = 1 : n 
        temp_tel = tel((k-1)*d+1:k*d); 
        ftel = abs(fft(temp_tel,fs)); 
        
        max = ftel(675); 
        for i=676:950
            if ftel(i) >= max
                max = ftel(i);
                lowFreq = i;
            end
        end

         max = ftel(1200);
         for z=1201:1500
            if ftel(z) >= max
                max = ftel(z);
                highFreq = z;
            end
         end
    
    
       
        if lowFreq <= 720
            i=1; 
        elseif lowFreq <= 790 && lowFreq >= 697
            i=2;
        elseif lowFreq <= 885 && lowFreq >= 780
            i=3;
        else
            i=4;
        end  
    
        

        if highFreq <= 1300 && highFreq >= 1200 
            j=1;
        elseif highFreq <= 1477 && highFreq >= 1300
            j=2;
        else
            j=3;
        end
    
    fprintf(" %c",(numpad(i,j)));
    %subplot(n,1,k);
    %plot(ftel(1:1750));
    %title(numpad(i,j));
    end
    fprintf("\n");
 end

