

"""
2022년 9월 2일. 오후 4시51분. - copy 점검 완료.
"""




############################# 가지고 프레임 dfGaji ###################################
function slGaji_si_won_id()
    # ## global_dfDolColEreum-"CPD3_100_DOLBHBS"
    println("function slGaji_si_won_id() 시작")

    global dfGaji=DataFrame()  ## dfGaji 최초 생성 - 원천을 읽은 프레임으로부터 프레임가지가 최초 생성된다.
    # 입력되는 프레임의 100평돌변발 컬럼이 변발시 원천아이디를 기록하여 프레임가지를 최초생성한다.
    # 새 원천 자료의 끝까지 시원아이디가 산출된다.
    # 그런데 프레임 1행은 100평돌변발이 무조건 0처리 돼 있다.
    # 그러므로 프레임가지는 프레임 1행 초과부터 시작된다.
    # 연결: df 프레임을 받아서 그것의 100평돌변발 컬럼을 사용하여 시원아이디를 만들기에 
    # 포문 1회전(1행)에서는 무조건 시원아이디가 나오지 않음.
    # 2. 1행도 변발 발생할 수 있음.

    won_idDle=Vector()

    ###### 본격
    for ffa in 1:nrow(df)

        if abs(df[ffa,global_dfDolColEreum])==1

            push!(won_idDle,df[ffa,"WON_ID"])
        end
    end

    insertcols!(dfGaji,"SI_WON_ID"=>won_idDle)  ## 결. 프레임으로. dfGaji 최초 붙이기.
    println("dfGaji 최초 생성, 최초 붙이기 된")

    println("function slGaji_si_won_id() 끝")
end




function slGaji_gaji_id()  ## 입력: 프레임 가지.
    # 연결: 입력받은 프레임 가지의 행수 만큼 여기서 아이디가 생성됨. 
    # 별로도 df 를 참고하는게 아님. 
    println("function slGaji_gaji_id() 시작")

    if sl_gaji100_idSu==0  ## 최초일시. 안깔렸을시.

        id=1  ## 시작아이디
        idDle=[i for i in id:id+nrow_dfGaji-1 ]  
        insertcols!(dfGaji,1,global_gajiMet_id=>idDle)  ## 결. 프레임으로.  
        # 이 경우 [1,2,3,4,...]

    elseif sl_gaji100_idSu>=1  ## 깔렸을시
       
        df_gga=
        ChamGoRoDf(global_gajiMet_goEreum,dfGaji[1,"SI_WON_ID"],"<=","SI_WON_ID","<=",dfGaji[1,"SI_WON_ID"])

        id=df_gga[1,global_gajiMet_id]  ## 시작아이디 - 프레임 가지의 첫행은 기존 가지고에 있는 번호이다. 중복된다는 것.
        # 기존 가지고의 아이디가 1004부터 시작하면 아래 idDle 은 1004부터 시작됨.
        idDle=[i for i in id:id+nrow_dfGaji-1 ]    
        insertcols!(dfGaji,1,global_gajiMet_id=>idDle)  ## 결. 프레임으로.  
        # 이 경우 [211,212,213,...]
    end

    println("function slGaji_gaji_id() 끝")
end




function slGaji_si_sunDleWs()
    println("function slGaji_si_sunDleWs() 시작")

    sunDleWsBBdle=Any[0 for i in 1:nrow_dfGaji]

    dfDocColDle=
    ["CPD3_25","CPD3_50","CPD3_100",
    "CPD3_200","CPD3_300","CPD3_400",
    "CPD3_600","CPD3_800","CPD3_1200","CPD3_2400",
    "GU_100","GU_200","GU_300",
    "GU_400","GU_600","GU_1200"]

    for ffa in 1:nrow_dfGaji

        hhSiWonId=dfGaji[ffa,"SI_WON_ID"]
        hhDoc1Heng=woncheonDf_won_idRo_doc(df,hhSiWonId,hhSiWonId,dfDocColDle)
      
        namesVV=["COLEREUM","GAB"]
        df_hhSi=binDf_sung(namesVV)

        for ffb in 1:length(dfDocColDle)
           
            hhDocCol=dfDocColDle[ffb]
            hhDocColGab=hhDoc1Heng[1,hhDocCol]

            hh1Heng=[hhDocCol,hhDocColGab]

            push!(df_hhSi,hh1Heng)  ## 결. 
        end
        ## [열 이름,값치] 다 붙은.
   
        sort!(df_hhSi,"GAB",rev=true)  ## 결. 역정렬.
        sunDleWsBB=copy(df_hhSi[:,"COLEREUM"])  ## 종.
      
        sunDleWsBBdle[ffa]=copy(sunDleWsBB)
    end

    insertcols!(dfGaji,"SI_SUNDLEWS"=>sunDleWsBBdle)

    println("function slGaji_si_sunDleWs() 끝")
end




function slGaji_gaji_siMi_yucryang(ib_soDongChi)
    println("function slGaji_gaji_siMi_yucryang(ib_soDongChi) 시작")

    ###############
    hh_ce_df_si_won_id_bun=1
    hh_ce_df_mac_won_id_bun=nrow(df)

    hh_ce_df_si_won_id_bun2=1
    hh_ce_df_mac_won_id_bun2=nrow(df)

    ###############
    yucryangDle=zeros(nrow_dfGaji)

    # @threads for ffa in 1:nrow_dfGaji
    for ffa in 1:nrow_dfGaji
    
        hhSiWonId=dfGaji[ffa,"SI_WON_ID"]  ## 100평돌변발시점 - 이 시점이 대상 가지의 막봉임.
        
        woncheonDf_won_idRo_bigyoKeugi01VV=woncheonDf_won_idRo_bigyoKeugi01(df,"WON_ID",hhSiWonId,0,
        hh_ce_df_si_won_id_bun,hh_ce_df_mac_won_id_bun)

        hhBigyoKeugi01=woncheonDf_won_idRo_bigyoKeugi01VV[1]
        ## 이 비교크기를 그대로 1대1 비율로 시미 가지 길이로도 삼음.
        hh_ce_df_si_won_id_bun=woncheonDf_won_idRo_bigyoKeugi01VV[2]
        hh_ce_df_mac_won_id_bun=woncheonDf_won_idRo_bigyoKeugi01VV[3]

        hhBigyoKeugi01=Int(round(hhBigyoKeugi01))

        macSiWonId=hhSiWonId  ## 대상 가지의
        jacWonId=macSiWonId-(hhBigyoKeugi01-1)  ## 대상 가지의

        woncheonDfRo_yucryangDoolVV=woncheonDfRo_yucryangDool(df,"WON_ID",jacWonId,macSiWonId,hhBigyoKeugi01,ib_soDongChi,
        hh_ce_df_si_won_id_bun2,hh_ce_df_mac_won_id_bun2)  

        siMi_yucryangDool=copy(woncheonDfRo_yucryangDoolVV[1])
        # ## 결. (역량,순간역량)
        hh_ce_df_si_won_id_bun2=woncheonDfRo_yucryangDoolVV[2]
        hh_ce_df_mac_won_id_bun2=woncheonDfRo_yucryangDoolVV[3]

        yucryangDle[ffa]=copy(siMi_yucryangDool[1])
    end

    insertcols!(dfGaji,"GAJI_SIMI_YUCRYANG"=>yucryangDle)

    println("function slGaji_gaji_siMi_yucryang(ib_soDongChi) 끝")
end




function slGaji_miSaSang(vv8JumDleDle)
    # ## 입력받는 8점들 수는 기준인 100평돌의 수 만큼(프레임 가지 행수 만큼)이고, 
    # 그 수 만큼 미사상들을 만들어서 가지고 프레임으로 한다.
    # 초기 8점들의 1~6번방중 0이 있을 시 이 함축은 모두 0으로 채워진 반환값을 낸다.
    # 연결: df의 100평돌변발과 가지 나뉨은 일치한다. 그 가지나뉨의 가지 시원아이디 현봉에 8점들 현봉이 산출되고
    # 그 8점들 현봉에 현봉의 미사상이 산출된다. 
    println("function slGaji_miSaSang(vv8JumDleDleDf) 시작")

    #################### 본격
    miSaSangDle=Any[0 for i in 1:length(vv8JumDleDle)]
    chungMacHengDle=Any[0 for i in 1:length(vv8JumDleDle)]  ## 충전재 막행

    ###############
    hh_ce_df_si_won_id_bun=1
    hh_ce_df_mac_won_id_bun=nrow(df)

    ###############
    # @threads for ffa in 1:length(vv8JumDleDle)  ## ffa==[[x,y],[x,y],[x,y],...]
    for ffa in 1:length(vv8JumDleDle) 
        # # 사실상: 가지고 대양에서 [x,y]==[원천의 원아디,평기울기울기200치]==[자연수인데 실수된,실수인데 실수된]
        # # 그러므로 가지고 대양에서 X==15 인데 15.0 된이다.
        # println(ffa)
        hh8JumDle=copy(vv8JumDleDle[ffa])

        if hh8JumDle[1][1]==0  ## 특수갈래 - 초기 8점들의 1~6번방중 0이 있을 시

            hhMiSaSang=[[0,0],[8,0,0]]  ## 결. 현재 미사상 구한. 향은 중립이 8임.
           
            chungMacHengDle[ffa]=ffa  ## 충전재 막행번 기록

        else  ## 일반갈래 - 8점들이 1번방까지 다 채워진 이후.

            siJum=copy(hh8JumDle[1][1])  ## 결. 시점. float 이고 됨. 사실상 자연수인데 실수된. 
            keutJum=copy(hh8JumDle[end][1])  ## 결. 끝점. float 이고 됨. 사실상 자연수인데 실수된. 

            #################### 향,고점,저점
            woncheonDf_won_idRo_docVV=woncheonDf_won_idRo_doc(df,hh_ce_df_si_won_id_bun,hh_ce_df_mac_won_id_bun,
            siJum,keutJum,["WON_ID","GI"])  ## 매회 이 프레임 갱신됨.

            hhDf=copy(woncheonDf_won_idRo_docVV[1])
            hh_ce_df_si_won_id_bun=woncheonDf_won_idRo_docVV[2]
            hh_ce_df_mac_won_id_bun=woncheonDf_won_idRo_docVV[3]

            hyangGogabJugabFF=hyangGogabJugab(hhDf[:,"GI"])  ## rra=(hyang,hhGoGab,hhJuGab)
            # ==여기서는 (정수,정수,정수)

            hhMiSaSang=[[copy(siJum),copy(keutJum)],hyangGogabJugabFF]  ## 결. 현재 미사상 구한.
        end

        miSaSangDle[ffa]=copy(hhMiSaSang)  ## 종. 프레임 가지 행수 만큼의 행.
    end
    ## miSaSangDle 마련됐음. 그러나 앞 쪽 행들이 충전재 이므로 
    # 깔린 가지고를 읽어 충전재를 진으로 교체하는 과정이 필요하다.

    #################### chungMacHengDle 막번 찾기
    ce_chungMacHengDle=1  ## 2023년 11월 22일 이후부터.
    # ce_chungMacHengDle=length(chungMacHengDle) 이었음.- 2023년 11월 22일까지.
    # ce_chungMacHengDle=nothing 이었음

    for ffa in 1:length(chungMacHengDle)

        if chungMacHengDle[ffa] !=0

            ce_chungMacHengDle=copy(chungMacHengDle[ffa])

        else

            break
        end
    end

    #################### 충전재 막행 이하 자료고 뒤져 진으로 채우기
    if sl_gaji100_idSu>=1  ## 자료고 최초 아닐시

        docJacGaji_id=dfGaji[1,global_gajiMet_id]
        docMacGaji_id=dfGaji[ce_chungMacHengDle,global_gajiMet_id]

        df_gga=ChamGoRoDf(global_gajiMet_goEreum,docJacGaji_id,"<=",global_gajiMet_id,"<=",docMacGaji_id)
        # ## 가지고 읽어 진 미사상 가져오기

        miSaSangDle=copy(miSaSangDle[ce_chungMacHengDle+1:end])  ## 앞쪽 자르기
        
        if df_gga !=nothing

            prepend!(miSaSangDle,copy(df_gga[:,"MISASANG"]))  ## 앞쪽 진 붙이기
        end
    end

    insertcols!(dfGaji,"MISASANG"=>miSaSangDle)  ## 종. 프레임 가지로.  
    # # 1개행==((15.0,155.0),(1,4015,3956))
    println("function slGaji_miSaSang(vv8JumDleDleDf) 끝")
end




function slGaji_miSa_gacSgh(vv8JumDleDle)
    println("function slGaji_miSa_gacSgh(vv8JumDleDleDf) 시작")

    gacSghDle=fill([],length(vv8JumDleDle))

    hh_ce_df_si_won_id_bun=1
    hh_ce_df_mac_won_id_bun=nrow(df)

    # @threads for ffa in 1:length(vv8JumDleDle)  ## ffa==[[x,y],[x,y],[x,y],...]  
    for ffa in 1:length(vv8JumDleDle)

        # # dfGaji 행수 만큼 회전
        hh8JumDleDle=copy(vv8JumDleDle[ffa])
        siJum=nothing
        keutJum=nothing

        if hh8JumDleDle[1][1]==0  ## 특수갈래 - 초기 8점들의 1~6번방중 0이 있을 시

            siJum=df[1,"WON_ID"]
            keutJum=df[1,"WON_ID"]

        else  ## 일반갈래 - 8점들이 1번방까지 다 채워진 이후.

            siJum=copy(hh8JumDleDle[1][1])  ## 결. 시점. float 이고 됨. 사실상 자연수인데 실수된. 
            keutJum=copy(hh8JumDleDle[end][1])  ## 결. 끝점. float 이고 됨. 사실상 자연수인데 실수된. 
        end

        woncheonDf_won_idRo_docVV=woncheonDf_won_idRo_doc(df,hh_ce_df_si_won_id_bun,hh_ce_df_mac_won_id_bun,
        siJum,keutJum,["SIGANHYUNG"])

        df_qqa=copy(woncheonDf_won_idRo_docVV[1])
        hh_ce_df_si_won_id_bun=woncheonDf_won_idRo_docVV[2]
        hh_ce_df_mac_won_id_bun=woncheonDf_won_idRo_docVV[3]

        wwa=ryulDoinWonsoYurutDleRo_wonsoHanaDle(df_qqa[!,1])

        gacSghDle[ffa]=copy(wwa)
    end

    insertcols!(dfGaji,"MISA_GACSGH"=>gacSghDle)

    println("function slGaji_miSa_gacSgh(vv8JumDleDleDf) 끝")
end




function slGaji_miSaGaroPocWaSeroPoc(dfGaji)
    # ## 초기 8점들의 1~6번방중 0이 있을 시 dfGaji["MISASANG"] 이 0으로 채워져 있다.
    # 그러므로 그때는 이 함축의 가로폭, 세로폭 모두 0 이 된다. 참평몇은 기들이 0 나열로 입력되도 작동함.
    # 입력만으로 순환 함축. 음양양.
    # 이 함축은 다른데서 재사용 되기에 입력이 있어야 함.
    println("function slGaji_miSaGaroPocWaSeroPoc(dfGaji) 시작")

    garoPocDle=repeat([0],nrow_dfGaji)
    seroPocDle=repeat([0],nrow_dfGaji)

    for ffa in 1:nrow_dfGaji  ## ffa==((시점,끝점),(향,고점,저점))
        # 프레임 가지의 행수만큼 회전함. 
        # dfGaji 미사상이 1행부터 진이 됐으므로 여기서 가로폭,세로폭도 1행부터 진이다.
        hhMisaSang=copy(dfGaji[ffa,"MISASANG"])
        hhGaroPoc=hhMisaSang[1][2]-hhMisaSang[1][1]  ## 음양양. 사실상 정수인데 실수된.
        hhSeroPoc=hhMisaSang[2][2]-hhMisaSang[2][3]  ## 음양양. 사실상 정수인데 실수된.

        garoPocDle[ffa]=hhGaroPoc
        seroPocDle[ffa]=hhSeroPoc
    end

    insertcols!(dfGaji,"MISAGAROPOC"=>garoPocDle)  ## 음양양.
    insertcols!(dfGaji,"MISASEROPOC"=>seroPocDle)  ## 음양양.
    ## dfGaji 의 가로폭, 세로폭 컬럼은 로 자료고 안됨.

    println("function slGaji_miSaGaroPocWaSeroPoc(dfGaji) 끝")
end




function slGaji_dfGaji_jicjunGajiGo_heng()
    
    docGajiGo_gaji_id=dfGaji[1,global_gajiMet_id]-1

    global dfGaji_jicjunGajiGo_heng=
    ChamGoRoDf(global_gajiMet_goEreum,docGajiGo_gaji_id,"<=",global_gajiMet_id,"<=",docGajiGo_gaji_id)
end




function slGaji_hon()
    # ## 초기 8점들의 1~6번방중 0이 있을 시 미사가로폭, 세로폭 모두 0이다.
    # 그래도 미사가로폭,세로폭은 가지고에서 수입해오므로 수치가 대입된다.
    # # dfGaji[ffa,"MISAGAROPOC_CPD3_50"] 와 dfGaji[ffa,"MISASEROPOC_CPD3_50"] 는 1행부터 진이다.
    println("function slGaji_hon() 시작")

    honDle=fill([],nrow_dfGaji)

    for ffa in 1:nrow_dfGaji

        hhGaro50Pg=dfGaji[ffa,"MISAGAROPOC_CPD3_50"]
        hhSero50Pg=dfGaji[ffa,"MISASEROPOC_CPD3_50"]
        hhHyang=dfGaji[ffa,"MISASANG"][2][1]  ## 향 - 1,-1,8

        rra=[hhGaro50Pg,hhSero50Pg,hhHyang]  ## 결. 가로100평, 세로100평은 음양양. 
        # 향은 -1,1,8 3가지 중 하나.
        honDle[ffa]=rra  ## 결. 붙이기. 프레임 가지 행수만큼.
    end

    insertcols!(dfGaji,"HON"=>honDle)
    ## 5일전부터 배치된 df로부터 온 5일 전부터의 dfGaji 의 "HON" 컬럼은 1행부터 진이다. 

    df_abDui_print(dfGaji)
    println("function slGaji_hon() 끝")
end




############################ dfGaji 중 일반으로 돌아와 ##################################
function slGaji_amsu(dfAmSunEreum)  ## 미래로부터 기록 방식 - 막봉은 충전재 처리.
    # dfGaji가 dfGaji를 낳는게 아니라 df의 100평돌변발 컬럼을 미세처리해 
    # dfGaji의 행수에 맞는 dfGaji를 낳는 방식.
    # 회차: 2회차가 되면 1회차 것을 기록하는 방식. 막회에 충전재 처리를 해줘야 하는 방식.
    # 입력- dfAmSunEreum-"CPD3_100"
    println("function slGaji_amsu() 시작")

    hhHoiCha=0
    suSun=Vector()
    amSun=Vector()
    amsuDle=Vector()

    for ffa in 1:nrow(df)

        if abs(df[ffa,global_dfDolColEreum])==1  ## 100평돌변발시만 push!
            # dfGaji 의 행수-1이 이곳의 결. 붙이기의 횟수임. 그래서 후반에서 길이 맞추기 함.

            hhHoiCha+=1

            if hhHoiCha>=2

                aaa=amsu(suSun,amSun)
                push!(amsuDle,aaa)  ## 결. 붙이기. 1,-1,8 3가지.
            end

            suSun=Vector()
            amSun=Vector()
            ## 숫선, 암선은 df의 100평돌변발시마다 초기화됨.
        end

        push!(suSun,df[ffa,"GI"])
        push!(amSun,df[ffa,dfAmSunEreum])
        ## df의 100평돌변발시마다 초기화되면 매회 붙이기.
    end

    if length(amsuDle)+1==nrow_dfGaji

        push!(amsuDle,1004)  ## 길이 맞추기 - 프레임 가지 막행재 1행 요인 발생.
    end

    insertcols!(dfGaji,"AMSU"=>amsuDle)  ## 결. 프레임으로. 
    # 1,-1,8 3가지인데 막행은 1004임.

    println("function slGaji_amsu() 끝")
end




function slGaji_GAJI_GACSGH()  ## 미래로부터 기록 방식 - 막봉은 천사 처리.
    # slGaji_amsu(df,dfGaji) 와 흐름 비슷.
    println("function slGaji_GAJI_GACSGH() 시작")

    hhHoiCha=0
    sghDle=Vector()
    gacSghDle=Vector()

    for ffa in 1:nrow(df)

        if abs(df[ffa,global_dfDolColEreum])==1

            hhHoiCha+=1

            if hhHoiCha>=2

                wwa=ryulDoinWonsoYurutDleRo_wonsoHanaDle(sghDle)
                push!(gacSghDle,wwa)  ## 결. 붙이기.
            end

            sghDle=Vector()
            ## sghDle 은 직전 100평돌변발부터 현 100평돌변발 직전봉까지 기록된 것.
        end

        push!(sghDle,df[ffa,"SIGANHYUNG"])  ## 매회 붙이기.
    end

    if length(gacSghDle)+1==nrow_dfGaji

        push!(gacSghDle,[1004] )  ## 길이 맞추기 - 프레임 가지 막행재 1행 요인 발생.
    end
    insertcols!(dfGaji,"GAJI_GACSGH"=>gacSghDle)  ## 결. 프레임으로. [100,180]

    println("function slGaji_GAJI_GACSGH() 끝")
end




function slGaji_gagam_gaji()
    println("function slGaji_gagam_gaji() 시작")

    hhGagamGab=nothing
    hhGagam_gaji=Vector()
    gagam_gajiDle=Vector()
    hhHoiCha=0

    for ffa in 1:nrow(df)

        if abs(df[ffa,global_dfDolColEreum])==1

            hhHoiCha+=1

            if hhHoiCha>=2  ## 돌변발 2회차때 이전 1회차의 것을 기록하는 방식

                push!(gagam_gajiDle,copy(hhGagam_gaji))
            end

            hhGagam_gaji=Vector()
        end

        if ffa==1

            hhGagamGab=0  ## 1행시 짜가 대입 - dfGaji 첫행재 요인 발생

        else

            hhGagamGab=df[ffa,"GI"]-df[ffa-1,"GI"]
        end

        push!(hhGagam_gaji,hhGagamGab)
    end

    if length(gagam_gajiDle)+1==nrow_dfGaji

        push!(gagam_gajiDle,copy(hhGagam_gaji))  ## 길이 맞추기 - dfGaji 막행재 요인 발생
    end

    insertcols!(dfGaji,"GAGAM_GAJI"=>gagam_gajiDle)  
    # ## gagam_gajiDle 1행==[+2,+1,-1,+3,-2,+2,...]

    println("function slGaji_gagam_gaji() 끝")
end




function slGaji_jjong_gaji()  ## 미래로부터 기록 방식 - 막봉은 천사 처리.
    # slGaji_amsu(df,dfGaji) 와 흐름 비슷.
    println("function slGaji_jjong_gaji() 시작")

    hhHoiCha=0
    jjongGab=df[1,"GI"]
    hhJjongBongGabDle=Vector()
    jjong_gajiDle=Vector()

    for ffa in 1:nrow(df)

        if abs(df[ffa,global_dfDolColEreum])==1

            hhHoiCha+=1

            if hhHoiCha>=2  ## 돌변발 2회차때 이전 1회차의 것을 기록하는 방식

                push!(jjong_gajiDle,copy(hhJjongBongGabDle))  ## 종. 붙이기. 음양 유.
            end

            if ffa==1  ## 특수갈래 - df의 ffa=1 행은 100평돌변발이 무조건 0이기 때문에
                # 이 갈래가 흐를 일은 없음. 보편성을 위해 존재함.
                jjongGab=df[1,"GI"]  ## 이래서 dfGaji 시를 버려야 함 
                # - 만약 ffa=1 행이 100평돌변발에서 통과된다면.

            elseif ffa>=2  ## 일반갈래

                jjongGab=df[ffa-1,"GI"]  ## 쫑값 갱신 부여
            end

            hhJjongBongGabDle=Vector()  ## 초기화
        end

        ###### 매회 붙이기
        hhJjongBongGab=df[ffa,"GI"]-jjongGab  ## 음양 유. 
        # jjongGab 최초화는 기의 1행값을 넣는 것이기 때문에 df 100평돌변발 1행이 통과된다고 해도
        # 첫행재 해야함.
        push!(hhJjongBongGabDle,hhJjongBongGab)  ## hhJjongBongGabDle==[+3,+5,+2,-1,-3,...] # 음양 유.
    end

    if length(jjong_gajiDle)+1==nrow_dfGaji

        push!(jjong_gajiDle,copy(hhJjongBongGabDle))  ## 길이 맞추기 - 프레임 가지 막행재 1행 요인 발생.
    end

    insertcols!(dfGaji,"JJONG_GAJI"=>jjong_gajiDle)  ## 쫑. 프레임으로. 한 행==[+3,+5,+2,-1,-3,...]. 음양 유.
    # 막행==[10041004]

    println("function slGaji_jjong_gaji() 끝")
end




function slGaji_jjong_geumgang()  ## 입력 dfGaji 가 [14] 여도 됨. 길이가 1이어도 됨.
    # 입력만으로 순환 함축.
    println("function slGaji_jjong_geumgang() 시작")

    geumgangDle=fill([],nrow_dfGaji)

    # @threads for ffa in 1:nrow_dfGaji
    for ffa in 1:nrow_dfGaji
        # ## 프레임 가지 자체가 포문의 기반이니 프레임 가지 행만큼 포문 회전하고 산출함.
        # 매회 대상 hh_jjong_gaji==[+3,+5,+2,-1,-3,...] # 음양 유.
        hh_jjong_gaji=copy(dfGaji[ffa,"JJONG_GAJI"])
        
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

    insertcols!(dfGaji,"JJONG_GEUMGANG"=>geumgangDle)  ## 종. 프레임으로. 

    println("function slGaji_jjong_geumgang() 끝")
end




function slGaji_jjong_giulGabWaGil()  ## 입력만으로 순환 함축.
    println("function slGaji_jjong_giulGabWaGil() 시작")

    giulGabDle=zeros(nrow_dfGaji)
    gilDle=zeros(nrow_dfGaji)

    for ffa in 1:nrow_dfGaji

        ## hh_jjong_geumgang 매회 대상. (1,(x,y),(x,y),(x,y),(x,y))
        hh_jjong_geumgang=copy(dfGaji[ffa,"JJONG_GEUMGANG"])

        giulGabWaGilCC=giulGabWaGil((hh_jjong_geumgang[2],hh_jjong_geumgang[5]))
    
        giulGabDle[ffa]=giulGabWaGilCC[1]  ## 결. 붙이기.
        gilDle[ffa]=giulGabWaGilCC[2]  ## 결. 붙이기.
    end

    insertcols!(dfGaji,"JJONG_GIULGAB"=>giulGabDle)  ## 종. 프레임으로. 
    insertcols!(dfGaji,"JJONG_GIULGABGIL"=>gilDle)  ## 종. 프레임으로. 

    println("function slGaji_jjong_giulGabWaGil() 끝")
end




function slGaji_jirebi_geumgang()
    # ## 혼의 가로폭, 세로폭 대비 쫑 금강의 비율. 혼의 향은 사용되지 않는다. 
    # 쫑금강의 향이 그대로 이것의 향이 된다.
    # 쫑가지가 음양유 이므로 쫑금강이 음양유이고 그래서 이 지레비금강도 음양유이다.
    # 입력만으로 순환 함축.
    # 중요: df의 100평돌변발이 발생하면 가지시원아이디가 기록되고 그 봉의 미사상이 그 봉에 생성된다.
    # 그러므로 그 봉의 혼도 그 봉에 생성된다. 이 현봉의 혼을 기반으로 해 
    # 현봉의 쫑 금강(미래로부터)의 비율을 현봉에 산출해 기록한다. 이게 지레비금강이다.
    println("function slGaji_jirebi_geumgang() 시작")

    geumgangDle=fill([],nrow_dfGaji)

    # @threads for ffa in 1:nrow_dfGaji
    for ffa in 1:nrow_dfGaji

        hhJjongGg=copy(dfGaji[ffa,"JJONG_GEUMGANG"])  ## 현재 쫑금강 - 매회 대상. 음양유.
        hhGaro_100Pg=dfGaji[ffa,"HON"][1]  ## 현재 가로100평. 음양양. HON==(hhGaro100Pg,hhSero100Pg,hhHyang).
        hhSero_100Pg=dfGaji[ffa,"HON"][2]  ## 현재 세로100평. 음양양.

        ###### 자료고 태초 특수처리 - 0 나누기 오류 방지
        if hhGaro_100Pg==0

            hhGaro_100Pg=CHg01_soDongChi*0.0001  ## 보정
        end

        if hhSero_100Pg==0

            hhSero_100Pg=CHg01_soDongChi*0.0001  ## 보정
        end

        hhHyang=hhJjongGg[1]  ## 결. 향 - 쫑금강의 향이 그대로 이 함축의 향이다.

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
        # # 향만 정수 나머지 모두 Float64.

        geumgangDle[ffa]=copy(rra)  ## 종. 붙이기. 프레임 가지의 행수만큼 회전하여 산출된.
    end

    insertcols!(dfGaji,"JIREBI_GEUMGANG"=>geumgangDle)  ## 쫑. 프레임 가지로.

    println("function slGaji_jirebi_geumgang() 끝")
end




function slGaji_jirebi_giulGabWaGil()
    # ## 프레임 가지 행수만큼 회전하여 산출함.
    # 입력만으로 순환 함축.
    println("function slGaji_jirebi_giulGabWaGil() 시작")

    giulGabDle=zeros(nrow_dfGaji)
    gilDle=zeros(nrow_dfGaji)

    # @threads for ffa in 1:nrow_dfGaji
    for ffa in 1:nrow_dfGaji

        # ## 매회 대상. hh_jirebi_geumgang==(-1,(x,y),(x,y),(x,y),(x,y))
        hh_jirebi_geumgang=copy(dfGaji[ffa,"JIREBI_GEUMGANG"])

        giulGabWaGilCC=giulGabWaGil((hh_jirebi_geumgang[2],hh_jirebi_geumgang[5]))
       
        giulGabDle[ffa]=giulGabWaGilCC[1]  ## 결. 붙이기.
        gilDle[ffa]=giulGabWaGilCC[2]  ## 결. 붙이기.
    end

    insertcols!(dfGaji,"JIREBI_GIULGAB"=>giulGabDle)  ## 종. 프레임으로. 
    insertcols!(dfGaji,"JIREBI_GIULGABGIL"=>gilDle)  ## 종. 프레임으로. 

    println("function slGaji_jirebi_giulGabWaGil() 끝")
end




function slGaji_miDalDle(dalGesooDle)  ## 미래도달들 - 도달갯수들 [20,40,80] 으로 하기로 함.
    # 입력만으로 순환 함축 + 글로벌 파견 1개.
    println("function slGaji_miDalDle(dalGesooDle) 시작")

    # global dfGajiJaJacHeng2=1004.1004  ## 초기화일 - 프레임가지 자를 시작행2
    dfGajiJaJacHeng2J1=Any[Inf for i in 1:nrow_dfGaji]

    lla=length(dalGesooDle)
    dalDle=Any[0 for i in 1:nrow_dfGaji]
   
    # @threads for ffa in 1:nrow_dfGaji
    for ffa in 1:nrow_dfGaji
        # ## 프레임 가지의 행수만큼 회전하여 산출함. 막판에 충전재도 산출함.
        hhDalDle=fill(0,lla)  ## 초기화일. [0,0,0] 이런거.

        hhGajiSiWonId=dfGaji[ffa,"SI_WON_ID"]
        df_gga=woncheonDf_won_idRo_doc(df,hhGajiSiWonId,hhGajiSiWonId,["GI"])

        hhJacGiGab=df_gga[1,1]
        
        #################### 본격 - 지점부터 50000봉 앞까지 검색
        hoiSu=1600  ## 손잡이 - 회전수. 원천을 수입한 df를 최대 몇행까지 뒤져볼 건지.

        for ffb in 1:hoiSu

            hhDocWonId=hhGajiSiWonId+ffb
            hhHoiGiGab=woncheonDf_won_idRo_doc(df,hhDocWonId,hhDocWonId,["GI"])
        
            ###### 본격의 본격
            if nrow(hhHoiGiGab)==0  ## 특수갈래 - 막판. df의 막원아이디를 초과해서 기값을 읽었을시.
                # global dfGajiJaJacHeng2=ffa  ## 자를시작행2 - 나중에 dfGaji 막행재할시를 위한 파견
                # break  ## 파견변수 기록하고 브레이크 - 브레이크시 hhDalDle 은 대체로 [20,0,0] 이런식.

                dfGajiJaJacHeng2J1[ffa]=ffa

            elseif nrow(hhHoiGiGab)>=1  ## 일반갈래

                hhHoiGiGab=hhHoiGiGab[1,1]
                hhDalGesoo=hhHoiGiGab-hhJacGiGab  ## 음양 유

                #### [-20,40,80] 이런거 산출
                for ffc in 1:lla

                    if hhDalDle[ffc]==0  ## 배치가 안됐을시만 산출

                        if hhDalGesoo>=abs(dalGesooDle[ffc])

                            hhDalDle[ffc]=abs(dalGesooDle[ffc])  ## 결. 배치.

                        elseif hhDalGesoo<=eumSu(dalGesooDle[ffc])

                            hhDalDle[ffc]=eumSu(dalGesooDle[ffc])  ## 결. 배치.
                        end
                    end
                end
            end

            if hhDalDle[end] !=0  ## 도달 다 구했으면 브레이크

                break
            end
        end

        #################### 종.
        dalDle[ffa]=copy(hhDalDle)  ## 종. 붙이기. hhDalDle=[-20,40,80], [-20,40,0], [0,0,0] 
    end

    #################### 자를 시작행2 정리 파견 
    global dfGajiJaJacHeng2=min(dfGajiJaJacHeng2J1...)

    if dfGajiJaJacHeng2==Inf

        global dfGajiJaJacHeng2=1004.1004
    end

    insertcols!(dfGaji,"MIDALDLE"=>dalDle)  ## 쫑. 프레임으로. 

    println("function slGaji_miDalDle(dalGesooDle) 끝")
end




function slGaji_dfGaji_hengJe()  ## 막행재, 첫행재 포함.
    println("function slGaji_hengJe() 시작")
  
    #################### 막행재설정
    hhJaJacHeng=1004.1004  ## 초기화일 - 현 자를 시작행 - dfGaji의 자를 시작행.

    if hhJaJacHeng==1004.1004  ## 특수갈래 - 이렇다 해도 막행재 함.

        global dfGaji=copy(dfGaji[1:end-1,:])  ## dfGaji 의 막행은 대부분 길이 맞추기 짜가이니까.
        # 가감가지, 쫑가지 등에서.

    elseif hhJaJacHeng !=1004.1004  ## 일반 갈래

        hhJaJacHeng=Int(round(hhJaJacHeng))

        global dfGaji=copy(dfGaji[1:hhJaJacHeng-1,:])  ## 막행재설정 완료 - 대부분 잘림.
        # 이래서 원천에 깔린 자료 시점보다 가지고의 막 자료 시점이 조금 짧게 됨.
    end

    #################### 첫행재설정
    if sl_gaji100_idSu==0  ## 특수갈래- 자료고 태초일시

        global dfGaji=copy(dfGaji[1:end-1,:])  ## 결. 로가지고할 dfGaji 마련 완료.
        # end-1: 아래 설명.
        ## dfGaji 앞쪽 행들에는 잘라야 할 충전재 등이 채워져 있는 경우가 많은데
        # 자료고 태초시는 그래도 로자료고 한다. 왜냐면 태초를 지나면 자료고 첫행재를 할 것이기 때문이다.

    elseif sl_gaji100_idSu>=1  ## 일반갈래- 최초 아닐시

        if global_gajiMet_id=="GAJI25_ID"

            hhGajiGo_macId=sl_gaji25_macId

        elseif global_gajiMet_id=="GAJI50_ID"

            hhGajiGo_macId=sl_gaji50_macId

        elseif global_gajiMet_id=="GAJI100_ID"

            hhGajiGo_macId=sl_gaji100_macId
        end
        ## 파견에서 받아온 막아이디로 행재

        macBun=dfHengBun(dfGaji,global_gajiMet_id,hhGajiGo_macId)  
        # ## 프레임가지의 "가지아이디"컬럼에서 hhGajiGo_macId 값이 위치한 행번을 반환함.

        ########
        global dfGaji=copy(dfGaji[macBun+1:end-1,:])  ## 결. 첫행재, 자료고에 부을 프레임. 
        # 거의 df기준 앞쪽행 1만행을 자르는 것이기 때문에 dfGaji의 앞쪽 행들에 자리잡은 충전재들 다 잘림.
        # end-1: dfGaji 는 미래로부터 기록 방식이 적용된게 많기 때문에 짜가 처리된 가지가 
        # 있을 수 있기 때문에 만약을 위해 자르는 것. 앞의 막행재설정에 이어 중복으로.
    end

    println("function slGaji_hengJe() 끝")
end




function slGaji_dfGaji_dfGo_colDle_sac()
    println(pyosic)
    println("slGaji_dfGaji_colDle_sac() 시작")

    select!(dfGaji,Not("MISAGAROPOC"))
    select!(dfGaji,Not("MISASEROPOC"))
    select!(dfGaji,Not("HON"))
    
    println("slGaji_dfGaji_colDle_sac() 끝")
end

