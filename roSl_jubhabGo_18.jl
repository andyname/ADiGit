

"""
1.
원천 자료고를 읽어 로접합고 대양의 기준 프레임을 만든다. 그 기준 프레임에 100평돌변발 컬럼같은 필요 컬럼을
이 대양 자체적으로 만든다. 그러므로 원천 자료고 수입만으로 순환 대양이 되는 것이다.

접합고 기준과 흐름: 접합고는 가지고 출신이 아니고 원천고로부터 최초 시작된다. 원천고가 
개장일 날 막까지로 끊겨서 기록돼 있어야만 한다. 이렇게 끊겨서 기록돼 있어야 기준이라 할 수 있는 
접형 컬럼 산출 slJub_df_jubHyung(df) 함축에서 막행시 갈래 처리가 된다. 이 함축도 df 의 100평돌변발의
영향력 아래 있다. 그걸 기준으로 삼아 그 변발 발생시 그 이전 가지에 해당하는 칸들을 채우는 방식인데,
이때 df의 막행에 다다를시 변발 발생 유무를 확인할 수 없기 때문에 그 이전 가지(df의 마지막 부분)를
기록할 수 없게 된다. 그런데 원천고가 날 막까지 끊겨서 기록돼 있으면 추정하여 기록하는게 가능해진다.

이 추정은 대체로 맞으나 한가지 결함이 있다. 평일에도 2일이상차 쉬는 날이 있을 수 있는 것이다. 
그러므로 종에 로자료고시 막행재를 한다. dfJub 은 날 막에 맞춰 산출돼 있으니 로자료고도 날 막에 맞추는게 좋다.
그래서 딱 1일치(1행 또는 2행)를 막행재 한다.

참고로 가지는 1봉짜리도 있는데 한 날이 시접합으로 뒤덮이는 특수갈래를 제외하곤
날의 막은 가지가 끊기거나 1봉짜리 가지로 끝나기 때문이고 그래서 특수갈래 제외하곤 막접합이 반드시 
생긴다. 그래서 추정에 기록하는게 일단 맞긴한거다. 기록 내용이 문제인거지.
결국 접합가지는 원천고의 자료끝까지 최초 생성되는 것이다. 100 비유에서 100까지 생성되는 것이다.

100 비유: 깔린 원천고가 100까지 기록돼 있다면 가지고는 98, 접합고는 90까지 기록돼 있다. 하루는 10으로 한다.
접합고 대양 준. df 최초 생성시 접합고 막아이디에서 -1(약 1일치) 부터 읽기 때문에 80부터 읽어서 df가 되는 것이다.
df 로부터 dfJub 이 최초 생성되기 때문에 dfJub 또한 80부터 산출된다.
독립적으로 생성되는 휘발성 프레임 dfHon 은 가지고를 읽어 60부터 배치가 된다. 비유가 60이지 
접합고 막 아이디에서 정확히 299개 전이다. 그래서 막 아이디까지 포함 이하 300개부터 dfHon 에 배치된다.
그러므로 100평인 혼 생성이 맞게 산출된다.

접형 시선 종류: (시접합),(시접합,끝접합),(시접합,일반가지,끝접합). 이 3가지만 있음.
#

2.
가지고 에서는 로고무 컬럼 HON 이 dfGaji 와 일치하기 때문에 dfGaji 로 갔지만
접합고에서는 dfJub 과 일치하지 않기 때문에 별도로 가야 한다. 시원아이디를 가지고 가야 한다.

3. 
dfJub 첫 행은 곳곳에서 짜가로 이뤄짐. 그래서 첫행재를 해야 함. 그런데 자료고 태초시엔 첫행재가 없음. 
짜가를 로고함.

2021년 11월 23일. 100 비유 에서 df 가 100 또는 1000까지 구해졌을때 
가지고는 98 또는 998 까지 구해질 수 밖에 없는 것이다.
하지만 접합고와 날고는 100 또는 1000까지 구하도록 정책이 변경됐다.
그에 따라 접합고의 slJub_dfJub_hengJe() 에서 막행재를 없앴다.

2022년 9월 2일. 오후 5시3분. - copy 점검 완료.
"""




function slJub_df_jubHyung()  ## 평일-평일 이면 130-110. 금요일-일요일 이면 330-310.
    # 원천를 수입한 df 에 시간형 컬럼처럼 접합형 컬럼을 붙이는 것. df의 매행에 접합형이 산출, 기록된다. 
    # 접합가지는 가지들 중에 1,2개 밖에 안되기 때문에 대부분의 행이 무인 0 으로 기록된다.
    # 입력만으로 순환 함축.
    # 순환점검: 자료고 최초시 ffa=1 일시 각종 경우들 점검됐음. 올바르게 기록됨.
    # 접형 시선 종류: (시접합),(시접합,끝접합),(시접합,일반가지,끝접합). 이 3가지만 있음.
    println("slJub_df_jubHyung() 시작")

    jubHyungDle=Vector()
    jacBongBun=0
    jacBongBunJ1=0
    junJubHyung=0
    hhJubHyungJ1=nothing
    hhJubHyung=0 
    
    for ffa in 1:nrow(df)
       
        ###### 시작봉번 기록 - 기록 허가가 날시 기록을 시작할 봉번이란 뜻.
        if abs(df[ffa,"CPD3_100_DOLBHBS"])==1 || df[ffa,"SIGANHYUNG"]>=100
            # ## 기록해야할 모든 경우 - 100평돌 변발시나 개장일 날 시작시

            jacBongBunJ1=jacBongBun  ## 이전일 - 이 변수는 이때만 이전됨.
            jacBongBun=ffa  ## 부여 - 이 변수는 이때만 부여됨.
        end
      
        ###### 붙일 변수 마련 - 참고: 원천고의 시간형은 자료고 태초 1행시에도 구해진다.
        hhJubHyungJ1=hhJubHyung  ## 이전일
        digitsRo_gabVV=digitsRo_gab(df[ffa,"SIGANHYUNG"],-2)
      
        if digitsRo_gabVV==1

            junJubHyung=130
            hhJubHyung=110

        elseif digitsRo_gabVV==2

            junJubHyung=230
            hhJubHyung=210

        elseif digitsRo_gabVV !=1004 && digitsRo_gabVV>=3

            junJubHyung=330
            hhJubHyung=310
            ## 개장일 날 시작시 - 전접형, 현접형 부여

        elseif abs(df[ffa,"CPD3_100_DOLBHBS"])==1  ## 날시작이 아닌 100평돌변발시(일상시)

            junJubHyung=0  ## 0 처리
            hhJubHyung=0  ## 0 처리
            ## 그외의 경우인데, 일상시는 전접형, 현접형 0 처리
        end
        ## (날 시작)-시접합-일상가지-일상가지-막접합-(날 막) 일시 hhJubHyungJ1==130 or 330-0-0-0 이다. 
        # 결. 붙이기에서 바로 위 그림을 생각하면 쉽다.
      
        #################### 결. 붙이기.
        # - 앞에서는 현봉에 맞게 변수를 마련하고 마련하면서 전1봉 변수를 만들어 놓는다.
        # 여기서 붙이기 해야할 상황을 만난다는건 현봉에 현봉을 기록해야 할 상황을 알았다는게 아니라 
        # 직전 과거의 접합 가지들이 붙여야 되는 상황이 됐다는 것을 알았다는 것이다.
        # 그래서 jacBongBunJ1:ffa-1 까지 현봉의 1직전봉까지 접형전1을 기록하는 것이다.
        # 대체로 ffa==1 시 시간형 100: 이것이 반영된다. 1행 이후 100평돌변발이 있을시 
        # 110 또는 310 으로 돼 있는 hhJubHyungJ1 이 기록되기 때문에 다 되는 것이다. 
      
        if ffa !=1  ## 자료고 최초가 아니라면 - 그 직전 것을 기록하는 것이기 때문에
            # 최초시에는 기록할게 없으니까. 대신 아래에 특수갈래가 있어 df 봉이 종일시 항상 기록된다. 

            ###### 붙이기 - 시접합, 일상시
            if abs(df[ffa,"CPD3_100_DOLBHBS"])==1 && df[ffa,"SIGANHYUNG"]<100
                # ## 현봉이 100평돌변발시인데 날 시작이 아닐시 

                for ffb in jacBongBunJ1:ffa-1

                    push!(jubHyungDle,hhJubHyungJ1)  ## 결. 붙이기.
                end
                ## 대부분의 경우는 날 시작또는 막이 아닌 일상 100평돌변발이다.
                # 또한 하루는 이러한 일상 100평돌변발의 연속으로 이뤄진다.
                # 그러므로 jacBongBunJ1:ff-1 까지 채우는게 연속되면 거의 df의 행수만큼 0이 채워진다.

            ###### 붙이기 - 막접합
            elseif df[ffa,"SIGANHYUNG"]>=100
                # ## 현봉이 날 시작일시 - 날 시작시는 전접형이 부여돼 있다.
                digitsRo_gabVV=digitsRo_gab(hhJubHyungJ1,-1)

                #### 일반갈래
                if digitsRo_gabVV !=1
                    # ## 직전 접형변수가 시접합이 아니라면 
                    # - 직전이 시접합으로 뒤덮인 하루가 아니었다면.
                    # 이에 따라 한 날은 (시접합,막접합)이 될 수 있다. (시접합,일반가지)가 아니라.
                    for ffb in jacBongBunJ1:ffa-1

                        push!(jubHyungDle,junJubHyung)  ## 결. 붙이기.
                    end

                #### 특수갈래 - 직전 한 날이 시접합으로 뒤덮였을 시. 직전 한 날 전체를 기록하는 것.    
                elseif digitsRo_gabVV==1
                    # ## 이때는 df가 100평돌변발을 만나지 못해 hhJubHyungJ1 이 0처리가 되지 않은 상태다.
                    for ffb in jacBongBunJ1:ffa-1

                        push!(jubHyungDle,hhJubHyungJ1)  ## 결. 붙이기.
                    end
                end   
            end
        end
        ## 최종 ffa의 현봉은 기록이 안된 상태이다. 
        # ffa의 현봉은 마지막에 꼭 거치는 다음의 특수갈래에서 기록된다.
    
        ###### 특수갈래 - df의 봉이 종일시. df가 실제 일의 마지막까지 수입했을 거라고 전제함.
        # 막판에 여기로 반드시 빠짐.
        if ffa==nrow(df)
            #### 준비
            digitsRo_gabVV=digitsRo_gab(hhJubHyung,-1)

            dtVV=Dates.epochms2datetime(df[ffa,"EPOCHMS"] )
            hhYoil=Dates.dayofweek(dtVV)

            #### 붙이기
            if digitsRo_gabVV==1  ## 특수갈래 - 한 날이 시접합으로 뒤덮였을 시.
                # hhJubHyung 이 110,310 부여 받고 갱신될 일이 없었으니까 110,310이 유지된 경우임.
                # 도중에 df 100평돌변발을 안만났으니 현접형이 0처리가 안돼 있는 것임.   
                for ffb in jacBongBun:ffa

                    push!(jubHyungDle,hhJubHyung)  ## 결. 붙이기.
                end

            elseif hhYoil==5  ## 현재시간이 금요일이면

                for ffb in jacBongBun:ffa

                    push!(jubHyungDle,330)  ## 결. 붙이기.
                end

            else  ## 현재시간이 금요일이 아니면

                for ffb in jacBongBun:ffa

                    push!(jubHyungDle,130)  ## 결. 붙이기.
                end
            end
            ## 이 특수갈래는 추정이다. 맞는 추정이다. 다 맞는데 1가지가 부족하다.
            # 금요일 이라고 반드시 330이 붙고, 평일이라고 반드시 130이 붙지 않는다.
            # 평일에도 2일차 쉬는 날이 존재할 수 있다. 일반갈래에서는 df의 시간형에 따라
            # 130,330이 부여된다. 그래야 맞다. 이곳에서 하는건 가정이다. 결국 막행재를 해야한다.
        end
    end

    insertcols!(df,"JUBHYUNG"=>jubHyungDle)  ## 결. 프레임으로. 
    # [0,0,0,130,130,130,110,110,110,0,0,0,...]

    println("slJub_df_jubHyung() 끝")
end




############################# dfJub ###################################
function slJub_si_won_id_wa_jubHyung()
    println("slJub_si_won_id_wa_jubHyung() 시작")

    global dfJub=DataFrame()  ## dfJub 최초 생성

    hhJubHyungJ1=nothing
    hhJubHyung=0  ## 이게 최초 0으로 돼 있어서 포문 최초행에서 변발이 기록되긴 함.

    won_idDle=Vector()  ##  slJub_si_won_id()
    hyungDle=Vector()  ## slJub_jubHyung()

    for ffa in 1:nrow(df)
        #################### 변발부
        hhJubHyungJ1=hhJubHyung  ## 이전일
        hhJubHyungBhBs=0  ## 처리일

        hhJubHyung=df[ffa,"JUBHYUNG"]

        if hhJubHyungJ1 !=hhJubHyung

            hhJubHyungBhBs=hhJubHyung  ## 변발변수
        end
        ## hhJubHyung 이 0으로 초기화돼 있기에 hhJubHyungJ1 이 0이 되고
        # df 1행의 접형 컬럼에 기별이 있을시 전1과 다르니까 변발기록이 통과돼서 
        # 1행부터 변발이 기록됨. 
        # 앞선 slJub_df_jubHyung(df) 함축에서도 df 1행시 시간형 100이 나올시가 반영되어
        # 떤 값(시접합)이 기록됨.

        #################### 변화시 기록부
        digitsRo_gabVV=digitsRo_gab(df[ffa,"SIGANHYUNG"],-2)

        if hhJubHyungBhBs !=0 || (digitsRo_gabVV !=1004 && digitsRo_gabVV>=1)
            # ## 접이 시작되는 모든 시점 - 변발시는 당연하고, 날이 시작시 
            # - 이때는 항상 시접합이 시작되므로.

            ######  slJub_si_won_id()
            push!(won_idDle,df[ffa,"WON_ID"])  ## 그 시점에 시원아이디 포착

            ###### slJub_jubHyung()
            hha=df[ffa,"JUBHYUNG"]  ## 그 시점에 df 의 접형 그대로 포착
            push!(hyungDle,copy(hha))

        end
    end

    insertcols!(dfJub,"SI_WON_ID"=>won_idDle)  ## dfJub 에 최초로 붙이기
    # dfJub 의 행수는 df에 생성된 막접합, 시접합의 개수와 일치한다.
    # df 1행이 막접합 또는 시접합이라면 시원아이디 기록된다.
    ## df는 80부터 읽어서 배치돼 있기 때문에 df로 부터 여기서 최초 생성되는 dfJub 도
    # 80부터 산출되는 것임.
    insertcols!(dfJub,"JUBHYUNG"=>hyungDle)

    println("slJub_si_won_id_wa_jubHyung() 끝")
end




function slJub_jub_id()  
    println("slJub_jub_id() 시작")

    if sl_jub_idSu==0  ## 최초일시. 안깔렸을시.

        id=1  ## 시작아이디
        idDle=[i for i in id:(nrow(dfJub)+id-1) ]  
        insertcols!(dfJub,1,"JUB_ID"=>idDle)  ## 결. 프레임으로.  

    elseif sl_jub_idSu>=1  ## 깔렸을시
      
        df_jja=
        ChamGoRoDf(CHg01_sl_jubhabGoEreum,dfJub[1,"SI_WON_ID"],"<=","SI_WON_ID","<=",dfJub[1,"SI_WON_ID"])
        # ## 직전에서 최초 생성된 dfJub 의 시원아이디 1행(80)에 해당하는 깔려있는 접합고의 접아이디

        id=df_jja[1,"JUB_ID"]  ## 시작아이디
        idDle=[i for i in id:(nrow(dfJub)+id-1) ]  ## 깔려있는 접합고의 접아이디 포함 이상 산출 
        insertcols!(dfJub,1,"JUB_ID"=>idDle)  ## 결. 프레임으로.  
    end

    println("slJub_jub_id() 끝")
end




function slJub_gagam_gaji_wa_jjong_gaji()
    println("slJub_gagam_gaji_wa_jjong_gaji() 시작")

    hhJubHyungJ1=nothing
    hhJubHyung=0  ## 이게 최초 0으로 돼 있어서 포문 최초행에서 변발이 기록되긴 함.
    gajiSanheureumJ1=nothing
    gajiSanheureum=0

    hhGagam_gaji=Vector()
    gagam_gajiDle=Vector()

    hhJjong_gaji=Vector()
    jjong_gajiDle=Vector()

    hhJjongGab=nothing

    for ffa in 1:nrow(df)
        #################### 변발원
        hhJubHyungJ1=hhJubHyung  ## 이전일
        hhJubHyungBhBs=0  ## 처리일

        hhJubHyung=df[ffa,"JUBHYUNG"]

        if hhJubHyungJ1 !=hhJubHyung

            hhJubHyungBhBs=hhJubHyung  ## 변발변수
        end

        #################### 변발 관련부
        gajiSanHurmBhBs=0  ## 보편처리일
        gajiSanheureumJ1=gajiSanheureum  ## 보편이전일

        digitsRo_gabVV=digitsRo_gab(df[ffa,"SIGANHYUNG"],-2)

        if hhJubHyungBhBs !=0 || (digitsRo_gabVV !=1004 && digitsRo_gabVV>=1)
            # ## 접이 시작되는 모든 시점 - 변발시는 당연하고, 날이 시작시 
            # - 이때는 항상 시접합이 시작되므로.
            gajiSanheureum+=1 
            ## gajiSanheureum 1이상이면 산출해야 함.

        elseif abs(df[ffa,"CPD3_100_DOLBHBS"])==1
            # ## 위 경우 아닌데 100돌변발이 발생시(가지 나뉜이 발생시) - 일상으로 돌아옮.
            gajiSanheureum=0  ## 산출 흐름 해제.
        end

        #################### 가지산출흐름변화발생 부여
        if gajiSanheureumJ1 !=gajiSanheureum

            if gajiSanheureumJ1>=1 && gajiSanheureum==0

                gajiSanHurmBhBs=gajiSanheureumJ1*10  ## 10,20 이런식. df 1행에서도 부여될 수 있음.

            else

                gajiSanHurmBhBs=gajiSanheureum  ## 1,2,3 이런식. 
            end

        end
        ## 이 변발 변수가 산출됐으므로 이후 이 변발을 기준으로 모든게 이뤄진다.

        #################### 본격. 변발 산출 이후.
        #################### 기록부
        if gajiSanHurmBhBs>=10 || (gajiSanHurmBhBs<10 && gajiSanHurmBhBs>=2)
            # ## 접합이다가 접합이 끝나면 붙이기. 또는 접합이다가 새접합이 시작되면 붙이기.
            push!(gagam_gajiDle,copy(hhGagam_gaji))  ## 종. 가감가지 기록 붙이기.
            hhGagam_gaji=Vector()

            push!(jjong_gajiDle,copy(hhJjong_gaji))  ## 종. 쫑가지 기록 붙이기.
            hhJjong_gaji=Vector()
        end

        #################### 산출부 - 여기서만 결 배열 변수에 붙여짐.
        if gajiSanheureum>=1

            if gajiSanHurmBhBs<10 && gajiSanHurmBhBs>=1

                hhGagam_gaji=Vector()
                hhJjong_gaji=Vector()

                if ffa==1

                    hhJjongGab=df[ffa,"GI"]  ## 최초행만 짜가 부여 - 이래서 대양 후반에서 첫행재 해야함.

                else

                    hhJjongGab=df[ffa-1,"GI"]
                end

                hhGagamGajiGab=df[ffa,"GI"]-hhJjongGab  ## 가감가지

            else

                hhGagamGajiGab=df[ffa,"GI"]-df[ffa-1,"GI"]  ## 가감가지
            end

            hhJjongGajiGab=df[ffa,"GI"]-hhJjongGab  ## 쫑가지

            push!(hhGagam_gaji,hhGagamGajiGab)  ## 결. gajiSanheureum이 1 이상일시만 기록 붙이기. 
            push!(hhJjong_gaji,hhJjongGajiGab)  ## 결. 
        end

        if ffa==nrow(df)  ## 막행시 개장일 날 막에 끊겨 있다는 전제니까 붙이기.
            # # 이래서 원천df가 개장일 날 막에 끊겨 있어야 함.
            push!(gagam_gajiDle,hhGagam_gaji)  ## 종. 가감가지 기록 붙이기.
            push!(jjong_gajiDle,hhJjong_gaji)  ## 종. 쫑가지 기록 붙이기.
        end
    end

    insertcols!(dfJub,"GAGAM_GAJI"=>gagam_gajiDle)
    insertcols!(dfJub,"JJONG_GAJI"=>jjong_gajiDle)

    df_abDui_print(dfJub)
    println("slJub_gagam_gaji_wa_jjong_gaji() 끝")
end




function slJub_jjong_geumgang()  
    # 입력만으로 순환 함축.
    println("slJub_jjong_geumgang() 시작")

    geumgangDle=fill([],nrow_dfJub)

    # @threads for ffa in 1:nrow_dfJub
    for ffa in 1:nrow_dfJub

        # ## 프레임 접 자체가 포문의 기반이니 프레임 접 행만큼 포문 회전하고 산출함.
        # 매회 대상. [+3,+5,+2,-1,-3,...] # 음양 유.
        hh_jjong_gaji=copy(dfJub[ffa,"JJONG_GAJI"])

        #### 시
        si=[1,copy(hh_jjong_gaji[1])]  ## (x,y). y 음양유.
        #### 고
        go=yucDeChatgi(hh_jjong_gaji)  ## (x,y). y 음양유.
        #### 저
        ju=yucSoChatgi(hh_jjong_gaji)  ## (x,y). y 음양유.
        #### 종
        jong=[length(hh_jjong_gaji),copy(hh_jjong_gaji[end])]  ## (x,y). y 음양유.

        #### 고저 선후 - 향 1,-1,8 3개 존재함.
        if ju[1]<go[1]

            sunHu=1

        elseif ju[1]>go[1] 

            sunHu=-1

        elseif ju[1]==go[1]

            sunHu=8
        end

        #### 결. 금강 만들고 붙이기
        geumgang=[sunHu,copy(si),copy(go),copy(ju),copy(jong)]  ## (-1,(x,y),(x,y),(x,y),(x,y)). 음양유.
      
        geumgangDle[ffa]=copy(geumgang)  ## 결. 붙이기.
    end

    insertcols!(dfJub,"JJONG_GEUMGANG"=>geumgangDle)  ## 종. 프레임으로. 

    println("slJub_jjong_geumgang() 끝")
end




function slJub_jjong_giulGabWaGil()  ## 입력만으로 순환 함축.
    println("slJub_jjong_giulGabWaGil() 시작")

    giulGabDle=zeros(nrow_dfJub)
    gilDle=zeros(nrow_dfJub)

    # @threads for ffa in 1:nrow_dfJub
    for ffa in 1:nrow_dfJub

        # ## 매회 대상. (1,(x,y),(x,y),(x,y),(x,y))
        hh_jjong_geumgang=copy(dfJub[ffa,"JJONG_GEUMGANG"])

        giulGabWaGilCC=giulGabWaGil((hh_jjong_geumgang[2],hh_jjong_geumgang[5]))
       
        giulGabDle[ffa]=giulGabWaGilCC[1]  ## 결. 붙이기.
        gilDle[ffa]=giulGabWaGilCC[2]  ## 결. 붙이기.
    end

    insertcols!(dfJub,"JJONG_GIULGAB"=>giulGabDle)  ## 종. 프레임으로. 
    insertcols!(dfJub,"JJONG_GIULGABGIL"=>gilDle)  ## 종. 프레임으로. 

    println("slJub_jjong_giulGabWaGil() 끝")
end




function slJub_hon()  ## 로고무 프레임 slJub_df_hon 마련
    # - slJub_df_hon의 "HON"은 이 대양의 dfJub 1행 이하 최대 가지부터 
    # 새로운 가지들 끝까지를 대상으로 하여 구해진다.
    # 중간 정리: 이 대양의 df는 80부터 1000까지 수입돼 있기 때문에 
    # dfJub 도 80부터 1000까지 산출돼 있다. 그러므로 slJub_df_hon 도 79,80부터 998까지 배치된다. 
    println("slJub_hon() 시작")

    global slJub_df_hon=DataFrame()  ## 로고무 프레임 접합 df_hon 최초 생성

    #################### 최초 가지 찾기
    """
    sql="SELECT SI_WON_ID FROM ADC_JJOIL_TS_SL02_GAJI100 "*
    "WHERE SI_WON_ID<=$(dfJub[1,"SI_WON_ID"]) ORDER BY SI_WON_ID DESC LIMIT 1;"
    """
    if dfJub[1,"SI_WON_ID"]==1  ## 자료고 태초시 갈래

        df_jacPilyo_gajiGo_si_won_id=nothing

    else  ## 일반 갈래

        df_jacPilyo_gajiGo_si_won_id=
        ChamGoRoDf(CHg01_sl_gaji100GoEreum,dfJub[1,"SI_WON_ID"]-30000,"<=","SI_WON_ID","<=",dfJub[1,"SI_WON_ID"])
        # ## 이 시원아이디부터 수입이 시작돼야 함. # LIMIT 1 이어서 충분히 큰수 -30000 해줌.
    end

    #################### df_gajiGo_misa 마련
    if df_jacPilyo_gajiGo_si_won_id==nothing  ## 특수 갈래 - 자료고 태초 등 시

        df_gajiGo_misa=copy(dfGaji[:,["SI_WON_ID","MISASANG","MISAGAROPOC_CPD3_50","MISASEROPOC_CPD3_50"]])
        # ## 가지고 세계의 dfGaji 를 수입해 온

    else  ## 일반 갈래 - 자료고 태초 아닐 시

        if df_jacPilyo_gajiGo_si_won_id[end,"SI_WON_ID"]<dfGaji[1,"SI_WON_ID"]  ## dfGaji 1행 보다 앞에 있을 시

            """
            sql="SELECT SI_WON_ID,MISASANG,MISAGAROPOC_CPD3_50,MISASEROPOC_CPD3_50 "*
            "FROM ADC_JJOIL_TS_SL02_GAJI100 "*
            "WHERE SI_WON_ID>=$(df_jacPilyo_gajiGo_si_won_id[end,"SI_WON_ID"]) AND SI_WON_ID<$(dfGaji[1,"SI_WON_ID"]) "*
            "ORDER BY SI_WON_ID ASC;"  
            """
            df_gajiGo_misa=
            ChamGoRoDf(CHg01_sl_gaji100GoEreum,
            df_jacPilyo_gajiGo_si_won_id[end,"SI_WON_ID"],"<=","SI_WON_ID","<",dfGaji[1,"SI_WON_ID"])
            # ## 시작필요 가지고 시원아이디 이상이니까 1행이상됨 
            select!(df_gajiGo_misa,"SI_WON_ID","MISASANG","MISAGAROPOC_CPD3_50","MISASEROPOC_CPD3_50")

            df_gajiGo_misa2=copy(dfGaji[:,["SI_WON_ID","MISASANG","MISAGAROPOC_CPD3_50","MISASEROPOC_CPD3_50"]])
            # ## 가지고 세계의 dfGaji 를 수입해 온

            if df_gajiGo_misa==nothing
                
                df_gajiGo_misa=df_gajiGo_misa2

            else

                append!(df_gajiGo_misa,copy(df_gajiGo_misa2))  ## 결. 합하기
            end

        else  ## dfGaji 1행이 더 앞일 시, 같거나

            df_gajiGo_misa=copy(dfGaji[:,["SI_WON_ID","MISASANG","MISAGAROPOC_CPD3_50","MISASEROPOC_CPD3_50"]])
            # ## 가지고 세계의 dfGaji 를 수입해 온
        end
    end

    #################### df_gajiGo_misa 마련 후
    ###### 이하 slGaji_hon()과 쌍둥이
    si_won_idDle=repeat([0],nrow(df_gajiGo_misa))
    honDle=fill([],nrow(df_gajiGo_misa))

    # @threads for ffa in 1:nrow(df_gajiGo_misa)
    for ffa in 1:nrow(df_gajiGo_misa)
      
        si_won_idDle[ffa]=df_gajiGo_misa[ffa,"SI_WON_ID"]

        hhGaro50Pg=df_gajiGo_misa[ffa,"MISAGAROPOC_CPD3_50"]
        hhSero50Pg=df_gajiGo_misa[ffa,"MISASEROPOC_CPD3_50"]
        hhHyang=df_gajiGo_misa[ffa,"MISASANG"][2][1]  ## 향 - 1,-1,8

        rra=[hhGaro50Pg,hhSero50Pg,hhHyang]  ## 결. 가로100평, 세로100평은 음양양. 
        # 향은 -1,1,8 3가지 중 하나.
        honDle[ffa]=copy(rra)  ## 결. 붙이기. 프레임 가지 행수만큼.
    end

    insertcols!(slJub_df_hon,"SI_WON_ID"=>si_won_idDle)
    insertcols!(slJub_df_hon,"HON"=>honDle)  ## 결. 접합고 대양에서 지레비 쪽을 구할 때 쓰일 slJub_df_hon 마련

    println("slJub_hon() 끝")
end




function slJub_jirebi_geumgang()  ## slGaji_jirebi_geumgang(dfGaji) 와 쌍둥이.
    # 접합고 종합 연결: 접합고의 막 아이디는 원천고의 끝까지 구해진데서 1일치 정도를 
    # 막행재해서 기록하기 때문에 100 비유에서 90이다.
    # dfJub 은 그 막 아이디(90)에서 1일치 전부터인 80부터 산출돼 있다.
    println("slJub_jirebi_geumgang() 시작")

    geumgangDle=fill([],nrow_dfJub)

    # @threads for ffa in 1:nrow_dfJub  ## 접의 행수만큼 회전하며 금강들을 산출함.
    for ffa in 1:nrow_dfJub 

        hhJjongGg=copy(dfJub[ffa,"JJONG_GEUMGANG"])  ## 현재 쫑금강 - 매회 대상. 음양유.
        hhSiWonId=dfJub[ffa,"SI_WON_ID"]  ## 접의 시원아이디는 가지 시원아이디와 일치하지 않음.

        ###### 현재 혼
        dfChamQueryVV=df_hengBunChatgi(slJub_df_hon,"SI_WON_ID","<=",hhSiWonId,-1,1)  ## DataFrame [찾은행번,행번값]
        # # hhSiWonId 의 이하 최대가지의 시원아이디 찾은 - 찾은행번의 slJub_df_hon 을 읽으면 됨.
        # 태초시: 자료고 태초시 사실상 안 구해진다. 왜냐면 태초시엔 시접합이 먼저 나오고
        # 가지고는 시접합 이후의 가지를 최초 가지로 볼 것이기 때문이다. 이때는 dfChamQuery가 "0×2 DataFrame" 반환한다.
        # 최후시: dfJub이 1000까지 배치돼 있고 가지고로부터 오는 slJub_df_hon이 998까지 배치돼 있어도 
        # 자료고 최후시 구해진다. 왜냐면 이하 최대 1개만 찾으면 되기 때문이다. 
        # 그 직전 가지가 중복해서 배치될 수 있음. 
        if nrow(dfChamQueryVV)==0  ## 자료고 태초시

            hhHon=copy(slJub_df_hon[1,"HON"])  ## 짜가 배치

        else

            hhHon=copy(slJub_df_hon[dfChamQueryVV[1,"CEHENGBUN"],"HON"])  ## 일반갈래
        end

        hhGaro_100Pg=hhHon[1]  ## 현재 가로100평. 음양양.
        hhSero_100Pg=hhHon[2]  ## 현재 세로100평. 음양양.

        ###### 자료고 태초 특수처리 - 0 나누기 오류 방지
        if hhGaro_100Pg==0

            hhGaro_100Pg=CHg01_soDongChi*0.0001  ## 보정
        end

        if hhSero_100Pg==0

            hhSero_100Pg=CHg01_soDongChi*0.0001  ## 보정
        end

        hhHyang=hhHon[3]  ## 결. 현재 향.

        #### 시
        siX=hhJjongGg[2][1]/hhGaro_100Pg
        siY=hhJjongGg[2][2]/hhSero_100Pg  ## 음양유.
        #### 고
        goX=hhJjongGg[3][1]/hhGaro_100Pg
        goY=hhJjongGg[3][2]/hhSero_100Pg  ## 음양유.
        #### 저
        juX=hhJjongGg[4][1]/hhGaro_100Pg
        juY=hhJjongGg[4][2]/hhSero_100Pg  ## 음양유.
        #### 종
        jongX=hhJjongGg[5][1]/hhGaro_100Pg
        jongY=hhJjongGg[5][2]/hhSero_100Pg  ## 음양유.

        rra=[hhHyang,[siX,siY],[goX,goY],[juX,juY],[jongX,jongY]]  ## 종. 음양유.
        geumgangDle[ffa]=copy(rra)  ## 종. 붙이기. 프레임 가지의 행수만큼 회전하여 산출된.
    end

    insertcols!(dfJub,"JIREBI_GEUMGANG"=>geumgangDle)

    println("slJub_jirebi_geumgang() 끝")
end




function slJub_jirebi_giulGabWaGil()
    # ## 프레임 접 행수만큼 회전하여 산출함.
    # 입력만으로 순환 함축.
    println("slJub_jirebi_giulGabWaGil() 시작")

    giulGabDle=zeros(nrow_dfJub)
    gilDle=zeros(nrow_dfJub)

    # @threads for ffa in 1:nrow_dfJub
    for ffa in 1:nrow_dfJub

        # ## 매회 대상. ffa==(-1,(x,y),(x,y),(x,y),(x,y))
        hh_jirebi_geumgang=copy(dfJub[ffa,"JIREBI_GEUMGANG"])

        giulGabWaGilCC=giulGabWaGil((hh_jirebi_geumgang[2],hh_jirebi_geumgang[5]))
        
        giulGabDle[ffa]=giulGabWaGilCC[1]  ## 결. 붙이기.
        gilDle[ffa]=giulGabWaGilCC[2]  ## 결. 붙이기.
    end

    insertcols!(dfJub,"JIREBI_GIULGAB"=>giulGabDle)  ## 종. 프레임으로. 
    insertcols!(dfJub,"JIREBI_GIULGABGIL"=>gilDle)  ## 종. 프레임으로. 

    println("slJub_jirebi_giulGabWaGil() 끝")
end




function slJub_dfJub_hengJe()  ## dfJub의 첫행재, 막행재 포함. 
    println("slJub_hengJe() 시작")

    ###### 첫행재 
    ## if sl_jub_idSu==0  ## 특수갈래- 최초일시 무일
    if sl_jub_idSu>=1  ## 일반갈래- 최초 아닐시

        macBun=dfHengBun(dfJub,"JUB_ID",sl_jub_macId,1)
        global dfJub=copy(dfJub[macBun+1:end,:])  ## 결. 첫행재설정. 자료고에 부을 프레임.
        # 접합에 깔린 막아이디 +1부터 끝까지. 
    end

    println("slJub_hengJe() 끝")
end

