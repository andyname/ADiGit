

"""
2022년 8월 31일. 오후 1시34분. - copy 점검 완료.
2022년 9월 2일. 오후 5시49분. - copy 점검 완료. 다시 완료.
"""




################ 초 second 컬럼이 없으면 막분 같은 걸로 만들어서 삽
# - 미국 트레이드스테이션 csv 에 초 없음.
function slWon_choColSab()
    
    namesVV=names(df)

    if "TIME" ∈ namesVV && "SECOND" ∉ namesVV
        # ## 분까지 나오는 time 컬럼은 있는데 초 컬럼이 없으면 통과

        ffa=1
        hhTimeJ1=nothing
        hhTime=df[ffa,"TIME"]

        hhJacBun=ffa
        cca=0

        choDle=Vector()

        for ffa in 1:nrow(df)

            hhTimeBhBs=0  ## 처리일

            hhTimeJ1=hhTime
            hhTime=df[ffa,"TIME"]

            if ffa==nrow(df)

                hhTimeJ1=hhTime-10041004  ## 막행시 변발발생 유도 처리
                cca+=1
            end

            if hhTime !=hhTimeJ1

                hhTimeBhBs=1004  ## 변화발생 부여
                cca_giroc=cca

                hhJacBun=ffa
                cca=0
            end

            cca+=1  ## 매봉 1증 일

            ################## 변화발생시 할 일
            if hhTimeBhBs==1004

                if ffa !=nrow(df)

                    giroc_bunCha=abs(df[ffa,"TIME"]-df[ffa-1,"TIME"])

                else

                    giroc_bunCha=1
                end

                if giroc_bunCha>=2300

                    giroc_bunCha=1
                end

                choDleJ1=Vector()

                for ffb in 1:cca_giroc

                    randVV=rand(0:59)
                    push!(choDleJ1,randVV)
                end

                sort!(choDleJ1)
                append!(choDle,choDleJ1)  ## 결결. 붙이기.
            end
        end

        choDle=bbRoRoundIntBB(choDle)

        dfColWcVV=dfColWc(df,"TIME")
        insertcols!(df,dfColWcVV+1,"SECOND"=>choDle)  ## df 에 삽
    end
end




################ 에포크밀리초 산출 삽
# select!(df,Not("EPOCHMS"))
# @time slWon_tsDateWaTimeRo_epochms_wa_epochms_jigu()
function slWon_tsDateWaTimeRo_epochms_wa_epochms_jigu()
    println(pyosic)
    println("function slWon_tsDateWaTimeRo_epochms_wa_epochms_jigu() 시작")

    epochmsDle=nothing

    ########
    namesVV=names(df)

    if "EPOCHMS" ∉ namesVV  ## 에포크밀리초 컬럼 없으면 통과

        epochmsDle=repeat([0],nrow(df))

        # @threads for ffa in 1:nrow(df)
        for ffa in 1:nrow(df)

            hhDt=TsSiganRoDateTime(df[ffa,"DATE"],df[ffa,"TIME"],df[ffa,"SECOND"])
            hhEpochms=Dates.datetime2epochms(hhDt)
            epochmsDle[ffa]=hhEpochms
        end

        insertcols!(df,"EPOCHMS"=>epochmsDle)
    end

    ########
    namesVV=names(df)

    if "EPOCHMS_JIGU" ∉ namesVV  ## 에포크밀리초 컬럼 없으면 통과

        insertcols!(df,"EPOCHMS_JIGU"=>df[:,"EPOCHMS"])
    end

    println("function slWon_tsDateWaTimeRo_epochms_wa_epochms_jigu() 끝")
end




################ df 시분초 구하기 - 시간형 1차 필요 컬럼.
function slWon_epochms_ro_sbc()  ## 입력만으로 순환 함축. - 시간형에서 시분초 씀.
    println(pyosic)
    println("function slWon_epochms_ro_sbc() 시작")

    dle=Vector()

    for ffa in 1:nrow(df)

        Sbc=epochmsRoSbc(df[ffa,"EPOCHMS"])  ## (시,분,초)
        push!(dle,Sbc)  ## 결. 붙이기.
    end

    insertcols!(df,"Sbc"=>dle)  ## 결.

    println("function slWon_epochms_ro_sbc() 끝")
end




################ 시차보정 - 뉴욕거래소, 시카고거래소 가 1시간차로 다르다.
function slWon_epochms_18SiJac_si_sichaBojung_se_epochms()

    global sichaBojung_pilyo=0

    for ffa in 1:nrow(df)-1

        hhSbc=df[ffa,"Sbc"]  ## 파견일
        hhSbcH1=df[ffa+1,"Sbc"]  ## 파견일

        if (sbcKeuJac([7,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[17,8,0])==2) &&
            (sbcKeuJac([17,55,0],hhSbcH1)==2 && sbcKeuJac(hhSbcH1,[18,40,0])==2)
            # ## 17시 막, 18시 시작이라면

            global sichaBojung_pilyo+=1  ## 결. 보정 필요한 부여.
        end

        if sichaBojung_pilyo>=4  ## 손잡이

            break
        end
    end

    ################# 보정 필요할 시만 보정
    if sichaBojung_pilyo>=1  ## 손잡이

        epochmsDle=copy(df[:,"EPOCHMS"])
        hanSigan=3600*1000
        seEpochmsDle=epochmsDle.-hanSigan

        colEreum="EPOCHMS"
        dfColWcVV=dfColWc(df,colEreum)
        select!(df,Not(colEreum))  ## 기존 컬럼 삭제
        insertcols!(df,dfColWcVV,colEreum=>seEpochmsDle)
    end
end




################ 개장일 시작부터로 앞쪽 끊기 - csv의 앞쪽을 끊는것.
function slWon_epochmsDool_ro_dfAbJe()
    println(pyosic)
    println("function slWon_epochmsDool_ro_dfAbJe() 시작")

    global slWon_csvAbCe=0  ## 순환의 시작인 csv의 앞쪽 깔린 자료고 막 다음에 맞는 곳 찾은 변수

    if sl_woncheon_idSu==0  ## 자료고 태초시

        ceJacBun=1004.1004

        for ffa in 1:nrow(df)

            hhSbc=epochmsRoSbc(df[ffa,"EPOCHMS"])  ## 자료고 태초시 시차 보정된 새 epochms 사용

            if sbcKeuJac([16,20,0],hhSbc)==2 && sbcKeuJac(hhSbc,[17,40,0])==2
                # ## 현재 시간이 16시 45분~ 17시15분15초 사이면. 찾은.

                ceJacBun=ffa
                break
            end
        end

        if ceJacBun !=1004.1004

            global df=copy(df[ceJacBun:end,:])  ## csv로부터온 df 앞쪽 끊기. 대부분이 ffa==1 에서 끊김.
            global slWon_csvAbCe=1004  ## 이 변수가 1004 이어야 원천고 대양 순환함.

            println("function slWon_epochmsDool_ro_dfAbJe() / 찾은 성공. ceJacBun=$ceJacBun / ceGotEpochmsCha=자료고 태초인")

        else
            println("function slWon_epochmsDool_ro_dfAbJe() / 찾은 실패. 원천고 순환 중단해야 함.")
        end

    elseif sl_woncheon_idSu>=1  ## 자료고 태초 아닐 시

        ceJacBun=1004.1004
        goMacHengDaeumCe=0  ## 고막행다음찾은 변수

        for ffa in 1:nrow(df)

            if df[ffa,"EPOCHMS_JIGU"]>df_sl_woncheon_macHeng[1,"EPOCHMS_JIGU"]  ## "EPOCHMS" 이었음.

                goMacHengDaeumCe=1  ## 결.
            end

            if goMacHengDaeumCe==1

                hhSbc=epochmsRoSbc(df[ffa,"EPOCHMS"])  ## 여기는 시차 보정된 epochms 로

                if sbcKeuJac([16,40,0],hhSbc)==2 && sbcKeuJac(hhSbc,[23,40,0])==2
                    # ## 현재 시간이 16시 45분~ 17시15분15초 사이면. 찾은.
                    # ## 원래 "if sbcKeuJac([16,20,0],hhSbc)==2 && sbcKeuJac(hhSbc,[17,40,0])==2" 이었음.
                    ceJacBun=ffa
                    break
                end
            end
        end

        if ceJacBun !=1004.1004

            if ceJacBun==1

                ceGotEpochmsCha=1004.1004

            else

                ceGotEpochmsCha=df[ceJacBun,"EPOCHMS"]-df[ceJacBun-1,"EPOCHMS"]
            end

            global df=copy(df[ceJacBun:end,:])  ## csv로부터온 df 앞쪽 끊기. 대부분이 ffa==1 에서 끊김.
            global slWon_csvAbCe=1004  ## 이 변수가 1004 이어야 원천고 대양 순환함.

            println("function slWon_epochmsDool_ro_dfAbJe() / 찾은 성공. ceJacBun=$ceJacBun / ceGotEpochmsCha=$ceGotEpochmsCha")

        else
            println("function slWon_epochmsDool_ro_dfAbJe() / 찾은 실패. 원천고 순환 중단해야 함.")
        end
    end

    println("slWon_csvAbCe=$slWon_csvAbCe")
    println("function slWon_epochmsDool_ro_dfAbJe() 끝")
end




################ 개장일 막까지로 뒷쪽 끊기 - csv의 뒷쪽을 끊는것.
function slWon_epochms_ro_dfDuiJe()
    println(pyosic)
    println("function slWon_epochms_ro_dfDuiJe() 시작")

    cemacBun=1004.1004

    for ffa in nrow(df):-1:1

        hhSbc=epochmsRoSbc(df[ffa,"EPOCHMS"])

        if sbcKeuJac([9,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[16,40,0])==2
            # ## 현재 시간이 15시 44분~ 16시15분 사이면. 찾은.
            cemacBun=ffa  ## 절대번
            break
        end
    end

    if cemacBun !=1004.1004
        
        global df=copy(df[1:cemacBun,:])  ## csv로부터온 df 뒷쪽 끊기. 대부분이 ffa==nrow(df) 에서 끊김.
    end

    println("nrow(df)=$(nrow(df)) / cemacBun=$cemacBun")
    println("function slWon_epochms_ro_dfDuiJe() 끝")
end




################# 기 확정 - 입력만으로 순환 함축 - siganHyung_1c_nalJacBunDle 필요함.
function slWon_giHwacWaGesooHwa(ib_soDongTick,yanghoGesoo)
    # ## 입력: 기간차 인정 양호개수 / # 기존 yanghoGesoo=4 였음.
    println(pyosic)
    println("function slWon_giHwacWaGesooHwa() 시작")

    ################## 실버 미국TS 자료 보정 특수
    if ChamGoEreum=="ChamGo_jjSilverCs"

        bojungOdle=Vector()
        bojungHdle=Vector()
        bojungLdle=Vector()
        bojungCdle=Vector()

        for ffa in 1:nrow(df)

            hhGi=df[ffa,"O"]
            bojungO=chiRo_banollimChi(hhGi,ib_soDongTick)
            push!(bojungOdle,bojungO)

            hhGi=df[ffa,"H"]
            bojungH=chiRo_banollimChi(hhGi,ib_soDongTick)
            push!(bojungHdle,bojungH)

            hhGi=df[ffa,"L"]
            bojungL=chiRo_banollimChi(hhGi,ib_soDongTick)
            push!(bojungLdle,bojungL)

            hhGi=df[ffa,"C"]
            bojungC=chiRo_banollimChi(hhGi,ib_soDongTick)
            push!(bojungCdle,bojungC)
        end

        colEreum="O"
        dfColWcVV=dfColWc(df,colEreum)
        select!(df,Not(colEreum))  ## 기존 컬럼 삭제
        insertcols!(df,dfColWcVV,colEreum=>bojungOdle)

        colEreum="H"
        dfColWcVV=dfColWc(df,colEreum)
        select!(df,Not(colEreum))  ## 기존 컬럼 삭제
        insertcols!(df,dfColWcVV,colEreum=>bojungHdle)

        colEreum="L"
        dfColWcVV=dfColWc(df,colEreum)
        select!(df,Not(colEreum))  ## 기존 컬럼 삭제
        insertcols!(df,dfColWcVV,colEreum=>bojungLdle)

        colEreum="C"
        dfColWcVV=dfColWc(df,colEreum)
        select!(df,Not(colEreum))  ## 기존 컬럼 삭제
        insertcols!(df,dfColWcVV,colEreum=>bojungCdle)
    end

    #
    ##########
    yanghoGesooChi=ib_soDongTick*yanghoGesoo

    giDle=Vector()

    global slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu=0

    ################## 프레임 1행 기확정
    if sl_woncheon_idSu==0  ## 자료고 태초시

        #### 일반차일시 기확정
        if abs(df[1,"C"]-df[2,"C"])<=yanghoGesooChi

            push!(giDle,df[1,"C"])  ## 기확정

        else  ## 이상차일시 기확정

            OHLC=["O","H","L","C"]

            hab=0  ## 시고저종 합

            for ffc in OHLC

                hab+=df[1,ffc]
            end

            pyung1=hab*0.25  ## df 1행 평균

            hab=0  ## 시고저종 합

            for ffc in OHLC

                hab+=df[2,ffc]
            end

            pyung2=hab*0.25  ## df 2행 평균

            #### 1번봉 기찾기 - df 1행 시고저종을 평균내고 그것과 차가 가장 작은걸 기로 선정
            soCha=abs(pyung1-df[1,"O"])
            ceOHLC=nothing

            for ffc in OHLC

                hhCha=abs(pyung1-df[1,ffc])

                if hhCha<=soCha

                    soCha=hhCha
                    ceOHLC=ffc
                end
            end

            ce1bongGi=df[1,ceOHLC]

            #### 2번봉 기찾기
            soCha=abs(pyung2-df[2,"O"])
            ceOHLC=nothing

            for ffc in OHLC

                hhCha=abs(pyung2-df[2,ffc])

                if hhCha<=soCha

                    soCha=hhCha
                    ceOHLC=ffc
                end
            end

            ce2bongGi=df[2,ceOHLC]

            #### 1,2번봉 기평균 내어 기 확정
            ceGi=(ce1bongGi+ce2bongGi)*0.5

            push!(giDle,ceGi)  ## 기확정
        end

    elseif sl_woncheon_idSu>=1  ## 자료고 태초 아닐시

        ffa=1

        #### 일반차일시 기확정
        if abs(df[ffa,"C"]-(df_sl_woncheon_macHeng[1,"GI"]*ib_soDongTick))<=yanghoGesooChi
            # ## [ffa-1]: 현 종가와 직전봉 기와의 차이가

            push!(giDle,df[ffa,"C"])  ## 기확정

        else  ## 이상차일시 기확정

            local OHLC=["O","H","L","C"]
            giOHLCganCha=fill(0.0,4)

            for (index,ffc) in enumerate(OHLC)

                giOHLCganCha[index]=abs(df[ffa,ffc]-(df_sl_woncheon_macHeng[1,"GI"]*ib_soDongTick))
                # 기와 시고저종 각값과의 차
            end

            giColMyung=OHLC[argmin(giOHLCganCha) ]

            hhCeGi=df[ffa,giColMyung]  ## 결. 찾은 기.

            #
            ################# 찾은 기 양호개수에 부합하는지 확인, 보정
            hhGiGanCha=hhCeGi-(df_sl_woncheon_macHeng[1,"GI"]*ib_soDongTick)

            if abs(hhGiGanCha)>yanghoGesooChi  ## 양호개수치 0.08 넘으면 보정

                boJungSu=abs(hhGiGanCha)-yanghoGesooChi  ## 소동틱 비슷
                randVV=rand(ib_soDongTick:ib_soDongTick:2*ib_soDongTick)  ## 소동틱 2면 왔갔이 자연스러우니까
                boJungSu=rand(boJungSu-randVV:boJungSu+yanghoGesooChi+randVV)

            else

                boJungSu=0
            end

            if hhGiGanCha>=0  ## 양향시

                hhCeGi-=boJungSu  ## 보정

            else  ## 음향시

                hhCeGi+=boJungSu
            end

            ###################### 이후 df 쫙 전체 보정수 만들기
            boJungSu=abs(boJungSu)

            if hhGiGanCha>=0

                global slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu=eumSu(boJungSu)

            else

                global slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu=boJungSu
            end
            ## slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu==소동틱 비슷
           
            push!(giDle,hhCeGi)  ## 기확정
        end
    end

    #
    ################# 프레임 2행이상행 기확정
    for ffa in 2:nrow(df)

        hhDfC=df[ffa,"C"]+slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu  ## 보정된.

        #### 일반차일시 기확정
        if abs(hhDfC-giDle[ffa-1])<=ib_soDongTick*yanghoGesoo
            # ## [ffa-1]: 현 종가와 직전봉 기와의 차이가

            push!(giDle,hhDfC)  ## 기확정

        else  ## 이상차일시 기확정
            
            local OHLC=["O","H","L","C"]
            giOHLCganCha=fill(0.0,4)

            for (index,ffc) in enumerate(OHLC)

                giOHLCganCha[index]=abs(df[ffa,ffc]-giDle[ffa-1])
                # 기와 시고저종 각값과의 차
            end

            giColMyung=OHLC[argmin(giOHLCganCha) ]

            hhCeGi=df[ffa,giColMyung]  ## 결. 찾은 기.

            hhCeGi+=slWon_giHwacWaGesooHwa_ehooJunche_bojungDuSu  ## 결. 보정된.

            ################# 찾은 기 양호개수에 부합하는지 확인, 보정
            hhGiGanCha=hhCeGi-giDle[ffa-1]

            if abs(hhGiGanCha)>yanghoGesooChi

                boJungSu=abs(hhGiGanCha)-yanghoGesooChi
                randVV=rand(ib_soDongTick:ib_soDongTick:2*ib_soDongTick)  ## 소동틱 2면 왔갔이 자연스러우니까
                boJungSu=rand(boJungSu-randVV:boJungSu+yanghoGesooChi+randVV)

            else

                boJungSu=0
            end

            if hhGiGanCha>=0  ## 양향시

                hhCeGi-=boJungSu  ## 보정

            else  ## 음향시

                hhCeGi+=boJungSu
            end
          
            push!(giDle,hhCeGi)  ## 기확정
        end
    end

    giDle=giDle.*(1/ib_soDongTick)  ## 기 갯수화
    giDle=bbRoRoundBB(giDle)  ## ERROR: InexactError: Int64(4040.9999999999995). 이런거 방지용.
    giDle=convert.(Int,giDle)
    insertcols!(df,"GI"=>giDle)  ## 종. 기 컬럼 프레임에 추가

    println("function slWon_giHwacWaGesooHwa() 끝")
end




################ df 에포크밀리차 - 시간형 1차 필요 컬럼.
function slWon_epochmsCha()  ## 입력만으로 순환 함축.
    println(pyosic)
    println("function slWon_epochmsCha() 시작")

    chaDle=repeat([0],nrow(df))

    if sl_woncheon_idSu==0  ## 자료고 태초시

        epochmsCha=1004  ## 짜가 부여

    else

        epochmsCha=df[1,"EPOCHMS"]-df_sl_woncheon_macHeng[1,"EPOCHMS"]
    end

    chaDle[1]=epochmsCha ## 결. 최초행 epochmsCha 붙이기.
    # - csv 입력으로부터 온 df 가 깔린 원천고 다음에 딱 맞춰져 있다는 전제가 있어야 함.

    # @threads for ffa in 2:nrow(df)
    for ffa in 2:nrow(df)

        epochmsCha=df[ffa,"EPOCHMS"]-df[ffa-1,"EPOCHMS"]
        chaDle[ffa]=epochmsCha  ## 결. 2행 이후 붙이기.
    end

    insertcols!(df,"EPOCHMSCHA"=>chaDle)  ## 결.

    println("function slWon_epochmsCha() 끝")
end




################# 메움형 생성 - 메울건지 판단하여 메움을 부여한다.
# # 시간형 필요 없고, EPOCHMSCHA,Sbc 만으로 독립적으로 순환함.
# 자료고 태초 대비 시험 통과.
function slWon_meum_chulJungboDle_sung(ib_giGanCha_injungGesoo)
    println(pyosic)
    println("function slWon_meum_chulJungboDle_sung(ib_giGanCha_injungGesoo) 시작")

    ################ 손잡이들
    meum_pilyo_ms=55*60*1000  ## 손잡이 - 메움필요밀리초. # 추후 세계 파견 변수를 대입한다. # 20 분 이었음.
    meum_pilyo_boon=meum_pilyo_ms/(60*1000)
    ilJacSbc=(17,0,0)
    ilJacSbcJwa1=SbcDum(ilJacSbc,-1,[0,meum_pilyo_boon+1,0])  ## 20+1분 전 - 16시40분부터 인정이니까.
    ilJacSbcU1=SbcDum(ilJacSbc,1,[0,meum_pilyo_boon+1,0])  ## 20+1분 후 - 17시20분까지 인정이니까.

    ilMacSbc=(16,0,0)
    ilMacSbcJwa1=SbcDum(ilMacSbc,-1,[0,meum_pilyo_boon+1,0])
    ilMacSbcU1=SbcDum(ilMacSbc,1,[0,meum_pilyo_boon+1,0])

    global meum_pilyo=0  ## 변수 최초 생성
    global meum_chulJungboDle=Vector()  ## 변수 최초 생성

    ################ 회전
    for ffa in 2:nrow(df)  ## df 2행부터 시작함. 1행은 언제나 메움 불인정.
        meum_pilyoBs=0  ## 보편처리일

        if df[ffa,"EPOCHMSCHA"]>meum_pilyo_ms  ## 1차 조건

            hhSbc=epochmsRoSbc(df[ffa,"EPOCHMS"])

            if !(sbcKeuJac(ilJacSbcJwa1,hhSbc)==2 && sbcKeuJac(hhSbc,ilJacSbcU1)==2)
                # ## 2차 조건 - 위 조건(17시 근방)은 ! 일시 통과

                hhSbcJ1=epochmsRoSbc(df[ffa-1,"EPOCHMS"])

                if !(sbcKeuJac(ilMacSbcJwa1,hhSbcJ1)==2 && sbcKeuJac(hhSbcJ1,ilMacSbcU1)==2)
                    # ## 3차 조건 - 위 조건(16시 근방)은 ! 일시 통과 - 이제 메움 따짐.

                    ###### 에포크밀리초차 32평균 만들기 - 현행 ffa 의 직전행부터 과거로 32개
                    epochmsChaDle=Vector()

                    for ffb in ffa-1:-1:ffa-1-(32-1)

                        if ffb<1

                            ffb=1
                        end

                        if df[ffb,"EPOCHMSCHA"]<=meum_pilyo_ms

                            push!(epochmsChaDle,df[ffb,"EPOCHMSCHA"])
                        end
                    end
                    if length(epochmsChaDle)==0

                        push!(epochmsChaDle,df[ffa-1,"EPOCHMSCHA"])  ## 혹시 결과 무일시 대입
                    end
                    epochmsCha32Gyun=mean(epochmsChaDle)  ## 결. 에포크밀리초차 32평균.

                    ###### 32평균 대비 현 에포크밀리초차 배수 구하기
                    hhBeSu=df[ffa,"EPOCHMSCHA"]/epochmsCha32Gyun

                    ###### 결. 메움 필요 판단
                    if hhBeSu>7  ## 7배 초과는 손잡이.

                        meum_pilyoBs=1  ## 결. 메움 필요 판정.

                    else  ## 기간차 인정개수 넘는지 판단

                        hhGiGanCha=df[ffa,"GI"]-df[ffa-1,"GI"]

                        if abs(hhGiGanCha)>ib_giGanCha_injungGesoo

                            meum_pilyoBs=1  ## 결. 메움 필요 판정.
                        end
                    end

                    ################## 메움 판정시 메움 출정보 만들기
                    if meum_pilyoBs==1

                        meum_pilyo+=1  ## 메움이 필요한 수만큼 글로벌 변수에 대입됨
                        global jungboDle=Dict()

                        push!(jungboDle,"JAC_ID"=>df[ffa-1,"ID"])
                        push!(jungboDle,"JAC_EPOCHMS"=>df[ffa-1,"EPOCHMS"])
                        push!(jungboDle,"JAC_DT"=>Dates.epochms2datetime(df[ffa-1,"EPOCHMS"]))
                        push!(jungboDle,"JAC_GI"=>df[ffa-1,"GI"])

                        push!(jungboDle,"MAC_ID"=>df[ffa,"ID"])
                        push!(jungboDle,"MAC_EPOCHMS"=>df[ffa,"EPOCHMS"])
                        push!(jungboDle,"MAC_DT"=>Dates.epochms2datetime(df[ffa,"EPOCHMS"]))
                        push!(jungboDle,"MAC_GI"=>df[ffa,"GI"])

                        ################ 좌표 산출
                        ganBongSu=(jungboDle["MAC_EPOCHMS"]-jungboDle["JAC_EPOCHMS"])/epochmsCha32Gyun

                        ganBongSu=Int(round(ganBongSu))  ## 음양 양
                        # ## 간격봉수 - 이 숫자로 간격이 이뤄져 있다고 보는 것임.

                        ganBongSuBan=Int(floor(ganBongSu*0.5))

                        if ganBongSuBan<CHg01_soDongChi

                            ganBongSuBan=CHg01_soDongChi  ## 보정
                        end

                        ganBongSuBan_na=Int(floor(ganBongSuBan*0.1))  ## 손잡이 0.1 # 음양 양

                        giChaJd=abs(df[ffa,"GI"]-df[ffa-1,"GI"])-1  ## 메움필요 기가 1~4까지면 2,3을 만드는 것이기 때문에 -1

                        if giChaJd<=0

                            giChaJd=0  ## 음수일시 보정
                        end

                        if df[ffa,"GI"]-df[ffa-1,"GI"]>=0  ## 상방시

                            jwapyo1=[(0,df[ffa-1,"GI"]+0),(ganBongSuBan,df[ffa-1,"GI"]+ganBongSuBan_na)]  ## ((x,y),(x,y))
                            jwapyo2=[(ganBongSuBan,df[ffa-1,"GI"]+ganBongSuBan_na),(ganBongSu,df[ffa-1,"GI"]+giChaJd)]

                        else  ## 하방시

                            jwapyo1=[(0,df[ffa-1,"GI"]+0),(ganBongSuBan,df[ffa-1,"GI"]-ganBongSuBan_na)]
                            jwapyo2=[(ganBongSuBan,df[ffa-1,"GI"]-ganBongSuBan_na),(ganBongSu,df[ffa-1,"GI"]-giChaJd)]
                        end

                        push!(jungboDle,"SUN1"=>copy(jwapyo1))  ## 결. 좌표1 붙이기.
                        push!(jungboDle,"SUN2"=>copy(jwapyo2))  ## 결. 좌표2 붙이기.

                        ################ 전후 주변 밀도(봉수) 기록 - 밀도: 1시간동안의 봉수
                        vv30BunEpochms=1800000
                        ###### 시작쪽
                        hhChatEpochms=jungboDle["JAC_EPOCHMS"]-vv30BunEpochms
                        ceDfHengBun=df_hengBunChatgi(df,"EPOCHMS","<=",hhChatEpochms,-1,1)

                        if nrow(ceDfHengBun) !=0

                            bongSu=(ffa-1)-ceDfHengBun[1,"CEHENGBUN"]+1  ## 결. 30분간 봉수
                            bongSu=bongSu*2  ## 결. 1시간간 봉수

                        else

                            bongSu=1004.1004
                        end

                        push!(jungboDle,"JAC_MILDO"=>copy(bongSu))  ## 결.

                        ###### 막쪽
                        hhChatEpochms=jungboDle["MAC_EPOCHMS"]+vv30BunEpochms
                        ceDfHengBun=df_hengBunChatgi(df,"EPOCHMS",">=",hhChatEpochms,1,1)

                        if nrow(ceDfHengBun) !=0

                            bongSu=ceDfHengBun[1,"CEHENGBUN"]-ffa+1  ## 결. 30분간 봉수
                            bongSu=bongSu*2  ## 결. 1시간간 봉수

                        else

                            bongSu=1004.1004
                        end

                        push!(jungboDle,"MAC_MILDO"=>copy(bongSu))  ## 결.

                        push!(meum_chulJungboDle,copy(jungboDle))  ## 종. 어레이에 기록.
                    end
                end
            end
        end
    end

    println("meum_pilyo=$meum_pilyo")
    println(meum_chulJungboDle)
    println("function slWon_meum_chulJungboDle_sung(ib_giGanCha_injungGesoo) 끝")
end




################ df 컬럼 자료형 Float64 로 바꾸기
function slWon_dfRoFloat64()
    println("function slWon_dfRoFloat64() 시작")

    ###### 형 변환
    df[!,"ID"]=convert.(Float64,df[:,"ID"])
    df[!,"EPOCHMS"]=convert.(Int64,df[:,"EPOCHMS"])
    df[!,"GI"]=convert.(Int64,df[:,"GI"])

    println("function slWon_dfRoFloat64() 끝")
end




################ 기 메움 - 사용 함축이 가지고 깔린 필요. 입력만으로 순환 함축.
function slWon_gi_meum()
    println(pyosic)
    println("function slWon_gi_meum() 시작")

    global bbDfBu_jackeutBunDle=Vector()  ## 시작끝번들 최초 생성

    if meum_pilyo>=1

        global dfBu=DataFrame("GI"=>[])  ## 추후 df 에 붙일 dfBu 최초 생성

        sijacBun=nothing
        keutBun=0

        for ffa in 1:meum_pilyo  ## 메움이 필요한 수만큼 회전

            hh_meum_chulJungbo=meum_chulJungboDle[ffa]  ## 딕셔너리

            ################### 기 만들기
            memoryGoGaji_sung(16)

            ################ 좌표1
            sunHana=hh_meum_chulJungbo["SUN1"]
            injo_giDleGaa=sunHanaRo_jjongGaji_giMeumDoin(1,sunHana,CHg01_soDongChi,0)

            ################ 좌표2
            sunHana=hh_meum_chulJungbo["SUN2"]
            injo_giDleNaa=sunHanaRo_jjongGaji_giMeumDoin(1,sunHana,CHg01_soDongChi,0)

            ################ 정리
            if length(injo_giDleNaa)<=1

                append!(injo_giDleGaa,injo_giDleNaa)

            else

                append!(injo_giDleGaa,injo_giDleNaa[2:end])
            end

            injo_giDle=injo_giDleGaa  ## 결. 인조기들 배치.

            ################### 종. 기 만든 이후 솎아내기 - 막분함
            ####### 막분 준비
            hh_JunMildo=(hh_meum_chulJungbo["JAC_MILDO"]+hh_meum_chulJungbo["MAC_MILDO"])*0.5
            # ## 결. 기준 밀도 구한. 1시간 동안 몇봉이 있어야 하나.

            hhEpochmsGanCha=hh_meum_chulJungbo["MAC_EPOCHMS"]-hh_meum_chulJungbo["JAC_EPOCHMS"]
            hhEpochmsGanChaBi=hhEpochmsGanCha/3600000  ## 비율=에포크밀리초둘차/1시간

            hhPilyoBongSu=hh_JunMildo*hhEpochmsGanChaBi  ## 결. 막분에 필요한 봉수
            hhPilyoBongSu=Int(round(hhPilyoBongSu))
      
            ####### 막분 본격
            injo_giDle2=ChamBB_macboon_st(injo_giDle,hhPilyoBongSu,2,CHg01_soDongChi)  ## 종. 막분
            injo_giDle2=bbRoRoundIntBB(injo_giDle2)

            ################### 종결. 솎아낸 이후
            sijacBun=keutBun+1  ## bbDfBu_jackeutBunDle 위한 # keutBun 최초는 0으로 초기화
            keutBun=sijacBun+length(injo_giDle2)-1  ## bbDfBu_jackeutBunDle 위한
       
            bunDool=(sijacBun,keutBun)
            push!(bbDfBu_jackeutBunDle,bunDool)  ## (시작한 행째번, 끝난 행째번) 여러개 다음으로 전달
            # [(1,100),(101,220),(221,700),...] - 메움출정보들과 일대일 대응 된다.
            dfHh=DataFrame("GI"=>copy(injo_giDle2))  ## 현재df
            append!(dfBu,dfHh)  ## 종. 행 붙이기 # dfBu 는 분절없이 기들만 나열된.
        end
    end

    df_abDui_print(dfBu,5,5)
    println("function slWon_gi_meum() 끝")
end




################ 에포크밀리초 메움 - 시작에포크 봉 더하기 1번 봉부터 막에포크 빼기 1번봉까지 만드는 것이 필요하다.
# 그래서 시작에포크 최근 미만을 쫑으로 잡고 시작에포크 최근 이상부터 막에포크 2근 이하까지 구하는게 기본이다.
# 그런데 함축 입력 쫑시간을 마련할때는 바로 위의 후반의 2근 이하점을 막에포크 빼기 1번봉에 가깝게 보정하는게 필요하다.
# 입력만으로 순환 함축.
function slWon_epochmsDul_meum()
    println(pyosic)
    println("function slWon_epochmsDul_meum() 시작")

    if meum_pilyo>=1

        injo_epochmsDle=Vector()

        for ffa in 1:meum_pilyo  ## 메움이 필요한 수 만큼 회전함.

            hhJungboDle=meum_chulJungboDle[ffa]  ## 매회대상
            println("epochmsDulRoSaiJjongMsDle2 시작")
            jjongEpochmsDle=epochmsDulRoSaiJjongMsDle2(hhJungboDle["JAC_EPOCHMS"]+15000,hhJungboDle["MAC_EPOCHMS"]-15000)
            # 15000 밀리초 더하고 빼는 이유: 기메움이 시작지점+1봉부터 막지점-1봉까지 됐기
            # 때문에 15초 후전으로 가정하는 것.
            println("jjongBB_gihwa 시작")
            md_epochmsBB=jjongBB_gihwa(hhJungboDle["JAC_EPOCHMS"],jjongEpochmsDle)  ## 결. 만든 에포크밀리초들

            #### 막분하기
            hhJackeutBun=bbDfBu_jackeutBunDle[ffa]
            macSu=hhJackeutBun[2]-hhJackeutBun[1]+1
            println("ChamBB_macboon_st 시작")
            hwac_epochmsBB=ChamBB_macboon_st(md_epochmsBB,macSu,2,CHg01_soDongChi)  ## 확정된 에포크밀리초들
            hwac_epochmsBB=bbRoRoundIntBB(hwac_epochmsBB)  ## 반올림,형변환

            append!(injo_epochmsDle,hwac_epochmsBB)  ## 결. 붙이기
        end

        insertcols!(dfBu,1,"EPOCHMS"=>injo_epochmsDle)  ## 종. dfBu에 삽. # dfBu 는 분절없이 에포크만 나열된.
        insertcols!(dfBu,"EPOCHMS_JIGU"=>injo_epochmsDle)
    end

    println("function slWon_epochmsDul_meum() 끝")
end




################ 아이디 메움
function slWon_id_meum()
    println(pyosic)
    println("function slWon_id_meum() 시작")

    if meum_pilyo>=1

        idDle=Vector()

        for ffa in 1:meum_pilyo  ## 메움이 필요한 수 만큼 회전함.

            ###### 준비
            hhJungboDle=copy(meum_chulJungboDle[ffa])  ## 매회대상
            hhMacJacIdCha=hhJungboDle["MAC_ID"]-hhJungboDle["JAC_ID"]
            hhMeumPilyoSu=bbDfBu_jackeutBunDle[ffa][2]-bbDfBu_jackeutBunDle[ffa][1]+1
            jarisu=roJarisu(hhMeumPilyoSu)[1]  ## 메움필요 자리수 - (소수점위, 소수점아래)
            hhDuSu=10.0^(-jarisu)

            ###### 본격
            for ffb in 1:hhMeumPilyoSu

                id=hhJungboDle["JAC_ID"]+(hhDuSu*ffb)
                push!(idDle,id)  ## 결. 붙이기.
            end

            sort!(idDle)
        end

        insertcols!(dfBu,1,"ID"=>idDle)  ## 종. dfBu에 삽. # dfBu 는 분절없이 아이디만 나열된.
    end

    println("function slWon_id_meum() 끝")
end




################ 합쳐진 df 만들기
function slWon_habDf()
    println(pyosic)
    println("function slWon_habDf() 시작")

    ###### 형 변환
    dfBu[!,"ID"]=convert.(Float64,dfBu[:,"ID"])
    dfBu[!,"EPOCHMS"]=convert.(Int64,dfBu[:,"EPOCHMS"])
    dfBu[!,"GI"]=convert.(Int64,dfBu[:,"GI"])
    dfBu[!,"EPOCHMS_JIGU"]=convert.(Int64,dfBu[:,"EPOCHMS_JIGU"])

    append!(df,dfBu)  ## 결. 합하기
    sort!(df,"ID")  ## 결. 아이디순 정렬.
    ## 재현 df 컬럼: ID,EPOCHMS,GI 3개.

    println("function slWon_habDf() 끝")
end




################ 시간형 1차 - 3째 자리만 구하는. 글로벌 변수 siganHyung_1c_moum_1c 만 파견하는게 목적.
function slWon_siganHyung_1c(coDulGan_ilGanCha)  ## coDulGan_ilGanCha 는 자료고 태초시만 영향력 유.
    println(pyosic)
    println("function slWon_siganHyung_1c(coDulGan_ilGanCha) 시작")

    ################## 준비
    sgh3JjeJariMoum=Vector()

    heureum=nothing
    jacBun=nothing
    jacBunJ1=nothing
    macBun=nothing
    jacBunSiEpochms=nothing
    hhDeChaWcBun=nothing
    epochmsDulRo_ilGanChiVV=nothing

    for ffa in 1:nrow(df)

        hhSbc=df[ffa,"Sbc"]  ## 파견일
        hhHyung=0  ## 처리일
        bonHuga=0  ## 처리일 - 본격허가 변수

        ################## 최초봉시 - 최초봉에서는 3가지 경우가 생기며 각 갈래별로 흐름을 최초 생성한다.
        if ffa==1

            ###### 현 시분초가 5시~17시미만 사이면
            if (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 ) &&
                sbcKeuJac(hhSbc,[17,0,0])==2

                heureum=11  ## 흐름변수 = ffa 1, 1번째
                jacBun=ffa
                jacBunSiEpochms=df[ffa,"EPOCHMS"]

            ###### 현 시분초가 17시~17시15분15초 사이면 - 일시초봉의 최대 간격을 15분 15초로 놓은 것임.
            # 대부분 원천고를 새로 깔때 이 갈래로 시작할 것임.
            elseif (sbcKeuJac([17,0,0],hhSbc)==8 || sbcKeuJac([17,0,0],hhSbc)==2 ) &&
                sbcKeuJac(hhSbc,[18,0,0])==2  ## 17시~17시15분15초 사이면

                heureum=12  ## 흐름변수 = ffa 1, 2번째
                hhDeChaWcBun=ffa  ## 현재기록할번

                if sl_woncheon_idSu==0  ## 자료고 태초시 - 최초 일간시 대입

                    epochmsDulRo_ilGanChiVV=coDulGan_ilGanCha

                else  ## 자료고 태초 아닐시

                    epochmsDulRo_ilGanChiVV=
                    epochmsDulGan_ilGanCha(df_sl_woncheon_macHeng[1,"EPOCHMS"],df[ffa,"EPOCHMS"],2)
                end

                hhHyung=(epochmsDulRo_ilGanChiVV+1)*100  ## 100-1일에 걸쳐 있다,200,300-3일에 걸쳐 있다.

                if hhHyung>800

                    hhHyung=800  ## 최대 8일(1주+1일)에 걸쳐 있다 까지로 제한.
                end

                hhMoum=[hhDeChaWcBun,hhHyung]
                push!(sgh3JjeJariMoum,hhMoum)  ## 결. 기록. # [(1,100),(999,100),(2401,300)]

            ###### 현 시분초가 17시15분15초~자정, 자정~5시미만 사이면
            elseif (sbcKeuJac([18,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[24,0,0])==2 ) ||
                ((sbcKeuJac([0,0,0],hhSbc)==8 || sbcKeuJac([0,0,0],hhSbc)==2) &&
                sbcKeuJac(hhSbc,[5,0,0])==2 )

                heureum=13  ## 흐름변수 = ffa 1, 3번째
                jacBun=ffa
                jacBunSiEpochms=df[ffa,"EPOCHMS"]
            end

            println("ffa=1 인 heureum=$heureum")
  
        elseif ffa>=2  ## 최초봉 초과시 - 최초봉 이후 흐름이 여러개로 보이나 결국 일상시인 28로 흐름전달을 하는 갈래들이다.

            ################ 상황별 준비원
            if heureum==11
               
                if df[ffa,"EPOCHMS"]-jacBunSiEpochms>=43200000  ## 에포크차가 12시간이상 날시 -
                    # 다음날의 그시간이 되면을 위해

                    ###### 5시지점시
                    if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                        (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                        # ## 4~6시 사이면서 # ## 5시 시

                        heureum=28 ## 흐름변수 = ffa 2이상, 일상
                        bonHuga=1004  ## 본격허가 변수 - 허락
                        jacBunJ1=jacBun  ## 이전일
                        jacBun=ffa  ## 시작번 - 다음차에
                        jacBunSiEpochms=df[ffa,"EPOCHMS"]
                        macBun=ffa-1  ## 막번
                    end
                end
               
            elseif heureum==12  ## 좀일, 흐름전달
              
                ###### 5시지점시
                if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                    (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                    # ## 4~6시 사이면서 # ## 5시 시

                    heureum=28 ## 흐름변수 = ffa 2이상, 일상
                    bonHuga=0
                    jacBun=ffa  ## 시작번 - 다음차에
                    jacBunSiEpochms=df[ffa,"EPOCHMS"]
                end
               
            elseif heureum==13  ## 무일, 흐름전달
              
                ###### 5시지점시
                if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                    (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                    # ## 4~6시 사이면서 # ## 5시 시

                    heureum=28 ## 흐름변수 = ffa 2이상, 일상
                end

            elseif heureum==28  ## 일상시 - 시작번 유 받음
          
                if df[ffa,"EPOCHMS"]-jacBunSiEpochms>=43200000  ## 에포크차가 12시간이상 날시 -
                    # 다음날의 그시간이 되면을 위해

                    ###### 5시지점시
                    if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                        (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                        # ## 4~6시 사이면서 # ## 5시 시

                        heureum=28 ## 흐름변수 = ffa 2이상, 일상
                        bonHuga=1004  ## 본격허가 변수 - 허락
                        jacBunJ1=jacBun  ## 이전일
                        jacBun=ffa  ## 시작번 - 다음차에
                        jacBunSiEpochms=df[ffa,"EPOCHMS"]
                        macBun=ffa-1  ## 막번
                    end
                end
            end

            ################ 본격 연산원 - 에포크밀리초 차가 가장 큰 지점을 찾아 형값 100, 200 부여
            # 인위임. # 최대차는 2개까지만 비교함.
            if bonHuga==1004

                ###### 지점(행번) 산출
                hhDeCha=[jacBunJ1,-1004]  ## 현재 최대차 초기화일
                println("ffa=$ffa / hhSbc=$hhSbc / jacBunJ1=$jacBunJ1 / macBun=$macBun")
                for ffb in jacBunJ1:macBun

                    ################ 특수 갈래- 시간형 성형- 유로 순환시 발견된 문제점 때문
                    if length(sgh3JjeJariMoum)==0 && ffb==jacBunJ1

                        hhDeCha=[ffb,df[ffb,"EPOCHMSCHA"]]
                        break
                    end

                    ################ 일반 갈래
                    hhSbc2=df[ffb,"Sbc"]

                    if sbcKeuJac([16,40,0],hhSbc2)==2 && sbcKeuJac(hhSbc2,[23,40,0])==2
                        # ## sbcKeuJac(hhSbc2,[24,0,0]) 원래 17시나 18시가 맞는데,
                        # 신한TS 자료의 빈 구간을 소화하기 위해 극단적으로 24로 설정했음.

                        if df[ffb,"EPOCHMSCHA"]>=hhDeCha[2]

                            hhDeCha=[ffb,df[ffb,"EPOCHMSCHA"]]
                            ## 같을시 최신봉으로 교체되는 방식이기 때문에 현기록번은 최초 1번, 0 에포크차였다 하더라도
                            # 1번 초과번이 됨. 모든 에포크차가 0이라면 0에포크차는 가능할 수 있음.
                        end
                    end
                end

                println("hhDeCha=$hhDeCha")
                #### 최대차 위치 확정하기
                hhDeChaWcBun=hhDeCha[1]  ## 결. 확정.

                # println("hhDeChaWcBun=$hhDeChaWcBun / df[hhDeChaWcBun,\"EPOCHMS\"]=$(df[hhDeChaWcBun,"EPOCHMS"])")

                ###### 형 산출
                #### 그 위치에 형 부여
                if sl_woncheon_idSu==0  ## 자료고 태초 시

                    if hhDeChaWcBun==1  ## 자료고 태초시 이 갈래

                        epochmsDulRo_ilGanChiVV=coDulGan_ilGanCha

                    else  ## 일상시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df[hhDeChaWcBun-1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)
                        # ## 현재 위치와 그 직전 위치의 에포크밀리초 차로 구함
                    end
                else  ## 자료고 태초 아닐시

                    if hhDeChaWcBun==1  ## 혹시 1행시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df_sl_woncheon_macHeng[1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)

                    else  ## 일상시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df[hhDeChaWcBun-1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)
                        # ## 현재 위치와 그 직전 위치의 에포크밀리초 차로 구함
                    end
                end

                hhHyung=(epochmsDulRo_ilGanChiVV+1)*100  ## 100-1일에 걸쳐 있다,200,300-3일에 걸쳐 있다.

                if hhHyung>800

                    hhHyung=800  ## 최대 8일(1주+1일)에 걸쳐 있다 까지만.
                end

                # println("(hhDeChaWcBun,hhHyung)=$((hhDeChaWcBun,hhHyung))")
                hhMoum=[hhDeChaWcBun,hhHyung]

                push!(sgh3JjeJariMoum,copy(hhMoum))  ## 결. 기록. # [(1,100),(999,100),(2401,300)] # 위치는 안내 행번
            end
        end
    end
    ## 이로써 날 막시 시인 시간형 3째 자리(1차)는 다 구해졌다. 다음에서 시간형 4째 자리를 구한다.

    global siganHyung_1c_moum_1c=sgh3JjeJariMoum  ## 전역 파견

    global siganHyung_1c_nalJacBunDle=Any[0 for i in 1:length(siganHyung_1c_moum_1c)]

    # @threads for ffa in 1:length(siganHyung_1c_moum_1c)
    for ffa in 1:length(siganHyung_1c_moum_1c)

        hhNalJacBun=siganHyung_1c_moum_1c[ffa][1]
        siganHyung_1c_nalJacBunDle[ffa]=hhNalJacBun
    end

    # println(sgh3JjeJariMoum[1])
    # println(sgh3JjeJariMoum[end])
    println("function slWon_siganHyung_1c(coDulGan_ilGanCha) 끝")
end




################ 날시작막번들 프레임 인위에 삽 - 프레임 인위 최초 생성.
# - siganHyung_1c_moum_1c 필요함
function slWon_df_inwe_nalJacmacBunDle()
    println(pyosic)
    println("function slWon_df_inwe_nalJacmacBunDle() 시작")

    bunDle=Vector()

    for ffa in 1:length(siganHyung_1c_moum_1c)

        if ffa!=length(siganHyung_1c_moum_1c)  ## 일상시

            jacBun=siganHyung_1c_moum_1c[ffa][1]
            macBun=siganHyung_1c_moum_1c[ffa+1][1]-1

        else  ## 막행이면

            jacBun=siganHyung_1c_moum_1c[ffa][1]
            macBun=nrow(df)
        end

        bunDool=[jacBun,macBun]
        push!(bunDle,copy(bunDool))
    end

    global df_inwe=DataFrame()  ## 프레임 인위 최초 생성
    insertcols!(df_inwe,"NALJACMACBUN"=>bunDle)  ## 종. 프레임으로. 프레임 인위 최초 붙이기.
    # bunDle= [(1,999),(1000,5005),(5006,8090),...] # 위치는 안내 행번

    println("function slWon_df_inwe_nalJacmacBunDle() 끝")
end




function slWon_nalJacSi_epochmsWaYoil()
    println(pyosic)
    println("slWon_nalJacSi_epochmsWaYoil() 시작")

    epochmsDle=Vector()
    yoilDle=Vector()

    for ffa in 1:nrow(df_inwe)

        hhDocBun=df_inwe[ffa,"NALJACMACBUN"][1]
        hhEpochms=df[hhDocBun,"EPOCHMS"]
        hhDt=Dates.epochms2datetime(hhEpochms)
        hhSiYoil=Dates.dayofweek(hhDt)

        push!(epochmsDle,hhEpochms)
        push!(yoilDle,hhSiYoil)
    end

    insertcols!(df_inwe,"NALJACSI_EPOCHMS"=>epochmsDle)
    insertcols!(df_inwe,"NALJACSI_YOIL"=>yoilDle)

    println("slWon_nalJacSi_epochmsWaYoil() 끝")
end




function slWon_roJjongEpochms()  ## 쫑시간 추출하여 프레임 인위에 배치. 입력만으로 순환 함축.
    println(pyosic)
    println("function slWon_roJjongEpochms() 시작")

    jjongDle=Vector()

    for ffa in df_inwe[:,"NALJACMACBUN"]

        #### 준비
        hhJjongGab=df[ffa[1],"EPOCHMS"]
        jjongHana=Vector()

        #### 본격
        for ffb in ffa[1]:ffa[2]  ## (1000,5005)

            rra=df[ffb,"EPOCHMS"]-hhJjongGab  ## 결. 구한 쫑시간.
            push!(jjongHana,rra)  ## 결. 붙이기. # [0,3,5,15,22,...]. 항상 0부터 시작함.
        end

        sort!(jjongHana)

        push!(jjongDle,copy(jjongHana))  ## 종. 붙이기.
    end

    insertcols!(df_inwe,"JJONGEPOCHMS"=>jjongDle)  ## 쫑. 프레임으로. 1행이 하루임.
    #  [[0,3,5,15,22,...], [0,13,15,25,32,...], [0,4,5,11,27,...],...]

    println("function slWon_roJjongEpochms() 끝")
end




function slWon_jjongEpochms_jjigle()  ## 입력만으로 순환 함축.
    println(pyosic)
    println("function slWon_jjongEpochms_jjigle() 시작")

    jjigleDle=Vector()

    for ffa in df_inwe[:,"JJONGEPOCHMS"]  ## ffa==[0,13,15,25,32,...]

        rra=ChamSiganBBroJjigle(ffa,0,82800000)  ## 23시간 분량으로 찌글 - 항상 1번봉 0밀리초, 막봉 82800000밀리초.
        rra=bbRoRoundBB(rra,0)
        rra=convert.(Int,rra)
        push!(jjigleDle,rra)  ## 결. 붙이기.
    end

    insertcols!(df_inwe,"JJIGLEEPOCHMS"=>jjigleDle)  ## 종. 프레임으로.
    #  [[0,3000,5000,15000,22000,...], [0,13000,15000,25000,32000,...], [0,4000,5000,11000,27000,...],...]

    println("function slWon_jjongEpochms_jjigle() 끝")
end




function slWon_jjigleEpochms_gihwa()  ## 종인 새에포크 밀리초 탄생. 입력만으로 순환 함축.
    # 앞선 찌글이 1번봉은 0밀리초, 막봉은 23시간인 82800000밀리초 이기 때문에 이 함축의 결과
    # 1번봉은 항상 17시 정각, 막봉은 16시 정각이다.
    println(pyosic)
    println("function slWon_jjigleEpochms_gihwa() 시작")

    ################ 준비
    haruEpochms=86400000  ## 하루치 에포크밀리초

    hh100200Wc=df_inwe[1,"NALJACMACBUN"][1]
    hhDfEpochms=df[hh100200Wc,"EPOCHMS"]
    choJjongEpochmsJ1=geunSbcEpochms_cg(hhDfEpochms,(17,0,0))  ## 최초쫑에포크밀리초 부여 -
    # 프레임인위의 1번행의 17시 정각에 해당하는 에포크 산출. 0점임.

    ################ 본격
    ###### choJjongEpochms 최초 구하기
    if sl_woncheon_idSu==0  ## 자료고 태초시

        choJjongEpochms=choJjongEpochmsJ1

    else  ## 자료고 태초 아닐시

        choJjongEpochmsJ1_yoil=df_inwe[1,"NALJACSI_YOIL"]

        hhDt=Dates.epochms2datetime(df_sl_woncheon_macHeng[1,"EPOCHMS"])
        sl_woncheon_macHeng_yoil=Dates.dayofweek(hhDt)  ## 원천고 막행의 요일

        if sl_woncheon_macHeng_yoil<=choJjongEpochmsJ1_yoil && choJjongEpochmsJ1_yoil<7

            pilyoYoil=sl_woncheon_macHeng_yoil

        elseif sl_woncheon_macHeng_yoil==7

            pilyoYoil=gejangil_jacTte_yoilDum(sl_woncheon_macHeng_yoil,1)

        elseif sl_woncheon_macHeng_yoil<=6 && (choJjongEpochmsJ1_yoil==7 || (1<=choJjongEpochmsJ1_yoil<=5))

            pilyoYoil=7
        end

        choJjongEpochms=epochmsDool_saiYoilSbcEpochms(
            df_sl_woncheon_macHeng[1,"EPOCHMS"],choJjongEpochmsJ1,pilyoYoil,[17,0,0])
        # ## 결. 언제나 일요일 때(17,0,0)에 맞춤. # 여기선 쫑의 의미가17시 정각 0점임.
        # # 만약 월요일부터 시작하는 특수 갈래라도 일요일 때부터 시작하게 맞춤.
    end

    moumDle=Vector()
    hh0JumJjongEpochms=choJjongEpochms

    for ffa in 1:nrow(df_inwe)
        ## hh0JumJjongEpochms 으로 최초행 돌고 for 막에서 참개장일로 1일 더하해서 다음회 전달 방식.

        tta=Dates.epochms2datetime(hh0JumJjongEpochms)
        # println("ffa=$ffa 행 시작 / hh0JumJjongEpochms=$tta")

        epochmsGiMoum=jjongBB_gihwa(hh0JumJjongEpochms,df_inwe[ffa,"JJIGLEEPOCHMS"] )
        # ## 결결. 기나열 [+3,+5,+8,+9,...]
        push!(moumDle,epochmsGiMoum)  ## 결결. 붙이기.

        ################## hh0JumJjongEpochms 다음날로 갱신하기
        if ffa!=nrow(df_inwe)

            hhDt=Dates.epochms2datetime(hh0JumJjongEpochms)
            hhSiYoil=Dates.dayofweek(hhDt)
            ## 여기선 쫑의 의미가17시 정각 0점임.

            hhDaeumSiYoil=df_inwe[ffa+1,"NALJACSI_YOIL"]

            if hhSiYoil<=5 && (hhDaeumSiYoil==7 || (hhDaeumSiYoil<hhSiYoil))  ## 주가 넘어가는 갈래시
                # - 일요일 때를 넘어가는 갈래시
                hh0JumJjongEpochms=epochmsDool_saiYoilSbcEpochms(hh0JumJjongEpochms,df_inwe[ffa+1,"NALJACSI_EPOCHMS"],7,[17,0,0])

            else  ## 주가 넘어가지 않는 갈래시 - 평일

                hh0JumJjongEpochms=ChamGejangilDumRo_sigan(hh0JumJjongEpochms,haruEpochms,1)
                # ## 참개장일로 1일씩 밀어야 정확하고 빠름.
                # # 최초날+0날,+1날,+2날,...
            end
        end

        tta=Dates.epochms2datetime(hh0JumJjongEpochms)
        # println("df_inwe $ffa 행 완료 / hh0JumJjongEpochms=$tta")
    end

    insertcols!(df_inwe,"DOINEPOCHMS"=>moumDle)  ## 종. 프레임으로.
    # [[15001,15010,15100,...],[17001,17099,17201,...],[19001,19098,19210,...],...]. 이런식.

    println("function slWon_jjigleEpochms_gihwa() 끝")
end




function slWon_inweEpochmsRoDf()  ## 입력만으로 순환 함축.
    println(pyosic)
    println("function slWon_inweEpochmsRoDf() 시작")

    epochmsDle=Vector()

    for ffa in df_inwe[:,"DOINEPOCHMS"]

        for ffb in ffa

            push!(epochmsDle,ffb)  ## 결. 붙이기.
        end
    end

    insertcols!(df,"EPOCHMS"=>copy(epochmsDle))  ## 종. 프레임으로.
    ## 현재 df 컬럼: ID,EPOCHMS,GI

    println("function slWon_inweEpochmsRoDf() 끝")
end




function slWon_epochmsRoundInt()  ## 자료고 입력전 동에포크밀리초 허용하는 것.
    println(pyosic)
    println("function slWon_epochmsRoundInt() 시작")

    epochmsDle=repeat([0],nrow(df))

    # @threads for ffa in 1:nrow(df)
    for ffa in 1:nrow(df)

        hhEpochms=df[ffa,"EPOCHMS"]
        roundDoin=Int(round(hhEpochms,digits=-3))  ## 1000 밀리초 단위로 반올림.
        epochmsDle[ffa]=roundDoin  ## 결. 붙이기.
    end

    ################ 삽
    colEreum="EPOCHMS"
    dfColWcVV=dfColWc(df,colEreum)

    select!(df,Not("EPOCHMS"))  ## 기존 에포크밀리초 컬럼 삭제 재정비

    insertcols!(df,dfColWcVV,"EPOCHMS"=>epochmsDle)  ## 종. 프레임으로.

    println("function slWon_epochmsRoundInt() 끝")
end




################ 시간형 - 3째 자리 먼저 구하는게 중심이다.
# 그 후 4째 자리, 2째 자리를 구함. 여기서 다 구함.
# df 의 Sbc, EPOCHMSCHA 컬럼을 씀.
# 자료고 태초 대비 시험 통과.
function slWon_siganHyung_modu(coDulGan_ilGanCha,ib_giGanCha_injungGesoo)
    # ## 입력: 최초둘간일간차- 자료고 태초시만 필요하나 혹시를 위해 일상시에도 최초행에 맞는 치를 입력하는게 했음.
    # 그러나 일상시 최초행 그리로 안 흐름.
    cca=0

    println(pyosic)
    println("function slWon_siganHyung_modu(coDulGan_ilGanCha,ib_giGanCha_injungGesoo) 시작")

    ################## 준비
    sgh3JjeJariMoum=Vector()

    heureum=nothing
    jacBun=nothing
    jacBunJ1=nothing
    macBun=nothing
    jacBunSiEpochms=nothing
    hhDeChaWcBun=nothing
    epochmsDulRo_ilGanChiVV=nothing

    for ffa in 1:nrow(df)

        hhSbc=df[ffa,"Sbc"]  ## 파견일
        hhHyung=0  ## 처리일
        bonHuga=0  ## 처리일 - 본격허가 변수

        ################## 최초봉시 - 최초봉에서는 3가지 경우가 생기며 각 갈래별로 흐름을 최초 생성한다.
        if ffa==1

            ###### 현 시분초가 5시~17시미만 사이면
            if (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 ) &&
                sbcKeuJac(hhSbc,[17,0,0])==2

                heureum=11  ## 흐름변수 = ffa 1, 1번째
                jacBun=ffa
                jacBunSiEpochms=df[ffa,"EPOCHMS"]

            ###### 현 시분초가 17시~17시15분15초 사이면 - 일시초봉의 최대 간격을 15분 15초로 놓은 것임.
            # 대부분 원천고를 새로 깔때 이 갈래로 시작할 것임.
            elseif (sbcKeuJac([17,0,0],hhSbc)==8 || sbcKeuJac([17,0,0],hhSbc)==2 ) &&
                sbcKeuJac(hhSbc,[18,0,0])==2  ## 17시~17시15분15초 사이면

                heureum=12  ## 흐름변수 = ffa 1, 2번째
                hhDeChaWcBun=ffa  ## 현재기록할번

                if sl_woncheon_idSu==0  ## 자료고 태초시 - 최초 일간시 대입

                    epochmsDulRo_ilGanChiVV=coDulGan_ilGanCha

                else  ## 자료고 태초 아닐시

                    epochmsDulRo_ilGanChiVV=
                    epochmsDulGan_ilGanCha(df_sl_woncheon_macHeng[1,"EPOCHMS"],df[ffa,"EPOCHMS"],2)
                end

                hhHyung=(epochmsDulRo_ilGanChiVV+1)*100  ## 100-1일에 걸쳐 있다,200,300-3일에 걸쳐 있다.

                if hhHyung>800

                    hhHyung=800  ## 최대 8일(1주+1일)에 걸쳐 있다 까지로 제한.
                end

                hhMoum=[hhDeChaWcBun,hhHyung]
                push!(sgh3JjeJariMoum,copy(hhMoum))  ## 결. 기록. # [(1,100),(999,100),(2401,300)]

            ###### 현 시분초가 17시15분15초~자정, 자정~5시미만 사이면
            elseif (sbcKeuJac([18,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[24,0,0])==2 ) ||
                ((sbcKeuJac([0,0,0],hhSbc)==8 || sbcKeuJac([0,0,0],hhSbc)==2) &&
                sbcKeuJac(hhSbc,[5,0,0])==2 )

                heureum=13  ## 흐름변수 = ffa 1, 3번째
                jacBun=ffa
                jacBunSiEpochms=df[ffa,"EPOCHMS"]
            end

            println("ffa=1 인 heureum=$heureum")

        elseif ffa>=2  ## 최초봉 초과시 - 최초봉 이후 흐름이 여러개로 보이나 결국 일상시인 28로 흐름전달을 하는 갈래들이다.

            ################ 상황별 준비원
            if heureum==11
            
                if df[ffa,"EPOCHMS"]-jacBunSiEpochms>=43200000  ## 에포크차가 12시간이상 날시 -
                    # 다음날의 그시간이 되면을 위해

                    ###### 5시지점시
                    if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                        (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                        # ## 4~6시 사이면서 # ## 5시 시

                        heureum=28 ## 흐름변수 = ffa 2이상, 일상
                        bonHuga=1004  ## 본격허가 변수 - 허락
                        jacBunJ1=jacBun  ## 이전일
                        jacBun=ffa  ## 시작번 - 다음차에
                        jacBunSiEpochms=df[ffa,"EPOCHMS"]
                        macBun=ffa-1  ## 막번
                    end
                end
            
            elseif heureum==12  ## 좀일, 흐름전달
           
                ###### 5시지점시
                if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                    (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                    # ## 4~6시 사이면서 # ## 5시 시
                    heureum=28 ## 흐름변수 = ffa 2이상, 일상
                    bonHuga=0
                    jacBun=ffa  ## 시작번 - 다음차에
                    jacBunSiEpochms=df[ffa,"EPOCHMS"]
                end
             
            elseif heureum==13  ## 무일, 흐름전달
             
                ###### 5시지점시
                if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                    (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                    # ## 4~6시 사이면서 # ## 5시 시
                    heureum=28 ## 흐름변수 = ffa 2이상, 일상
                end

            elseif heureum==28  ## 일상시 - 시작번 유 받음
         
                if df[ffa,"EPOCHMS"]-jacBunSiEpochms>=43200000  ## 에포크차가 12시간이상 날시 -
                    # 다음날의 그시간이 되면을 위해

                    ###### 5시지점시
                    if (sbcKeuJac([4,0,0],hhSbc)==2 && sbcKeuJac(hhSbc,[6,0,0])==2 ) &&
                        (sbcKeuJac([5,0,0],hhSbc)==8 || sbcKeuJac([5,0,0],hhSbc)==2 )
                        # ## 4~6시 사이면서 # ## 5시 시

                        heureum=28 ## 흐름변수 = ffa 2이상, 일상
                        bonHuga=1004  ## 본격허가 변수 - 허락
                        jacBunJ1=jacBun  ## 이전일
                        jacBun=ffa  ## 시작번 - 다음차에
                        jacBunSiEpochms=df[ffa,"EPOCHMS"]
                        macBun=ffa-1  ## 막번
                    end
                end
            end

            ################ 본격 연산원 - 에포크밀리초 차가 가장 큰 지점을 찾아 형값 100, 200 부여
            # 인위임. # 최대차는 2개까지만 비교함.
            if bonHuga==1004

                ###### 지점(행번) 산출
                hhDeCha=[jacBunJ1,-1004]  ## 현재 최대차 초기화일

                if ffa%11==0

                    println("ffa=$ffa / hhSbc=$hhSbc / jacBunJ1=$jacBunJ1 / macBun=$macBun")
                end

                for ffb in jacBunJ1:macBun

                    ################ 특수 갈래- 시간형 성형- 유로 순환시 발견된 문제점 때문
                    if length(sgh3JjeJariMoum)==0 && ffb==jacBunJ1

                        hhDeCha=[ffb,df[ffb,"EPOCHMSCHA"]]
                        break
                    end

                    ################ 일반 갈래
                    hhSbc2=df[ffb,"Sbc"]

                    if sbcKeuJac([16,40,0],hhSbc2)==2 && sbcKeuJac(hhSbc2,[24,0,0])==2
                        # ## sbcKeuJac(hhSbc2,[24,0,0]) 원래 17시나 18시가 맞는데,
                        # 신한TS 자료의 빈 구간을 소화하기 위해 극단적으로 24로 설정했음.

                        if df[ffb,"EPOCHMSCHA"]>=hhDeCha[2]

                            hhDeCha=[ffb,df[ffb,"EPOCHMSCHA"]]
                            ## 같을시 최신봉으로 교체되는 방식이기 때문에 현기록번은 최초 1번, 0 에포크차였다 하더라도
                            # 1번 초과번이 됨. 모든 에포크차가 0이라면 0에포크차는 가능할 수 있음.
                        end
                    end
                end

                # println("hhDeCha=$hhDeCha")

                #### 최대차 위치 확정하기
                hhDeChaWcBun=hhDeCha[1]  ## 결. 확정.

                # println("hhDeChaWcBun=$hhDeChaWcBun / df[hhDeChaWcBun,\"EPOCHMS\"]=$(df[hhDeChaWcBun,"EPOCHMS"])")

                ###### 형 산출
                #### 그 위치에 형 부여
                if sl_woncheon_idSu==0  ## 자료고 태초 시

                    if hhDeChaWcBun==1  ## 자료고 태초시 이 갈래

                        epochmsDulRo_ilGanChiVV=coDulGan_ilGanCha

                    else  ## 일상시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df[hhDeChaWcBun-1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)
                        # ## 현재 위치와 그 직전 위치의 에포크밀리초 차로 구함
                    end

                else  ## 자료고 태초 아닐시

                    if hhDeChaWcBun==1  ## 혹시 1행시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df_sl_woncheon_macHeng[1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)

                    else  ## 일상시

                        epochmsDulRo_ilGanChiVV=
                        epochmsDulGan_ilGanCha(df[hhDeChaWcBun-1,"EPOCHMS"],df[hhDeChaWcBun,"EPOCHMS"],2)
                        # ## 현재 위치와 그 직전 위치의 에포크밀리초 차로 구함
                    end
                end

                hhHyung=(epochmsDulRo_ilGanChiVV+1)*100  ## 100-1일에 걸쳐 있다,200,300-3일에 걸쳐 있다.

                if hhHyung>800

                    hhHyung=800  ## 최대 8일(1주+1일)에 걸쳐 있다 까지만.
                end

                hhMoum=[hhDeChaWcBun,hhHyung]
                push!(sgh3JjeJariMoum,copy(hhMoum))  ## 결. 기록. # [(1,100),(999,100),(2401,300)] # 위치는 안내 행번
            end
        end
    end
    ## 이로써 날 막시 시인 시간형 3째 자리(1차)는 다 구해졌다. 다음에서 시간형 4째 자리를 구한다.

    global siganHyung_1c_moum_modu=copy(sgh3JjeJariMoum)  ## 전역 파견

    ################## 결결. 4째,3째,시시 2째 자리 구하고 붙이기.
    sghDle=fill(0,nrow(df))  ## 종할 시간형들 최초 생성. 마련일.
    giGanCha=nothing

    # @threads for ffa in 1:length(sgh3JjeJariMoum)
    for ffa in 1:length(sgh3JjeJariMoum)

        println("cca=$cca"); cca+=1;

        hhSghMoum=sgh3JjeJariMoum[ffa]  ## 매회 대상: (999,100)

        ################ 시간형 4째 자리 구하기 - 기간차, 인정개수로
        if hhSghMoum[1]==1

            if sl_woncheon_idSu==0

                giGanCha=0

            else

                giGanCha=abs(df[hhSghMoum[1],"GI"]-df_sl_woncheon_macHeng[1,"GI"])
            end

        else

            giGanCha=abs(df[hhSghMoum[1],"GI"]-df[hhSghMoum[1]-1,"GI"])
        end

        ib_giGanCha_injungGesooBi=giGanCha/ib_giGanCha_injungGesoo

        if ib_giGanCha_injungGesooBi==0

            ib_giGanCha_injungGesooBi=0.001
        end

        hhSgh4JjeJari=((ceil(ib_giGanCha_injungGesooBi)-1)*1000)+1000
        ## 시간형 인정개수는 초과 이하임. 인정개수가 10이면 10까지는 1000, 11~20은 2000임.

        if hhSgh4JjeJari>9000

            hhSgh4JjeJari=9000  ## 인정개수 9배 까지로 제한.
        end

        hhSgh4JjeJari=Int(hhSgh4JjeJari)

        ################ 시간형 시시 2째자리 구하기
        hhSgh2JjeJari=hhSgh4JjeJari*0.01
        hhSgh2JjeJari=Int(hhSgh2JjeJari)

        ################ 결. 시간형 4째,3째,시시 2째 자리 더해서 시간형들로
        hhSghHab=hhSgh4JjeJari+hhSghMoum[2]+hhSgh2JjeJari  ## 결. 자리들 더하기. Int.

        hhWcBun=hhSghMoum[1]  ## 바꿀 위치 번
        sghDle[hhWcBun]=hhSghHab  ## 결결. 시간형들 바꿀 위치에 구한 시간형 대입함.
    end

    ################## 비시시 2째 자리 구하고 붙이기. - 시간흐름에 따라 10으로 감소해감.
    sgh2JjeJariGamGibonBong=500  ## 손잡이 - 시간형2째자리감소기본봉
    sgh2JjeJariGamInjungBong=500  ## 손잡이 - 시간형2째자리감소인정봉

    # @threads for ffa in 1:length(sgh3JjeJariMoum)
    for ffa in 1:length(sgh3JjeJariMoum)

        if ffa%11==0

            println("for ffa in 1:length(sgh3JjeJariMoum)")
        end

        hhSghMoum=copy(sgh3JjeJariMoum[ffa])  ## 매회 대상: (999,100)
        hhSghHabGab=copy(sghDle[hhSghMoum[1]])
        stta=string(hhSghHabGab)
        hhSgh2JjeJari=parse(Int,stta[end-1])*10  ## 매회 대상의 시간형 2째 자리만

        ################ 비시시 시간형 2째리 구하고 붙이기
        wwa=hhSghMoum[1]+1  ## 와번 초기화 - 비시시 최초봉 - 이 번호에 그대로 기록됨.

        while true

            if ffa !=length(sgh3JjeJariMoum) && wwa==sgh3JjeJariMoum[ffa+1][1]

                break  ## 다음 날 시작에 다다르면 기록 안하고 브레이크
            end

            hhBunDulGanCha=wwa-hhSghMoum[1]  ## 현번둘간차 - 초번(999)과 1증하는 와번 사이의 차
            ceGamSu=0

            for ffb in 8:-1:0  ## 최대 90부터 시작한다고 봄 그러니 감소수는 80이 최대

                hhDuBongSu=sgh2JjeJariGamGibonBong+(sgh2JjeJariGamInjungBong*ffb)
                ceGamSu=ffb  ## 찾은감소수 - 이 치 그대로 초시간형에서 감소 시킴

                if hhBunDulGanCha+1>hhDuBongSu

                    break
                end
            end

            hhGiroCsgh2JjeJari=hhSgh2JjeJari-(ceGamSu*10)  ## 결. 구한 기록할 시간형2째자리.

            if hhGiroCsgh2JjeJari<10

                hhGiroCsgh2JjeJari=10  ## 10이 일상시 정상값. 이 이하 없음.
            end

            sghDle[wwa]=hhGiroCsgh2JjeJari  ## 결결. 시간형들 원소 수정.
            # # sghDle은 원소가 df 행수만큼 있다.

            if wwa==length(sghDle)

                break  ## 막행에 다다르면 브레이크
            end

            wwa+=1
        end
    end
    ## 이로써 시간형 완전히 다 구했음.

    ################## 시간형 1째 자리 부여
    # @threads for ffa in 1:nrow(df)
    for ffa in 1:nrow(df)

        #println("################## 시간형 1째 자리 부여")

        hhId=df[ffa,"ID"]  ## 메움시 소수 유임.
        divremVV=divrem(hhId,1)

        if divremVV[2] !=0

            sgh1JjeJari=2  ## 메움 자료

        else

            sgh1JjeJari=1  ## 실제 자료
        end

        sghDle[ffa]=sghDle[ffa]+sgh1JjeJari  ## 결.
    end
    ## df의 행수와 sghDle 행수는 같다.

    insertcols!(df,"SIGANHYUNG"=>sghDle)  ## 종. 프레임으로.
    # sghDle=[3331,31,31,31,31,...,21,21,21,....,1111,11,11,11,11,...]

    println("function slWon_siganHyung_modu(coDulGan_ilGanCha,ib_giGanCha_injungGesoo) 끝")
end




################ df에 기간차 컬럼 마련 - 기간차 최대개수 넘는지 보려고
function slWon_giGanCha()

    chaDle=Any[0 for i in 1:nrow(df)]

    ################### 2행 이후 본격 - 1행은 0 부여
    # @threads for ffa in 2:nrow(df)
    for ffa in 2:nrow(df)

        hhGiGanCha=df[ffa,"GI"]-df[ffa-1,"GI"]
        chaDle[ffa]=hhGiGanCha
    end

    insertcols!(df,"GIGANCHA"=>chaDle)
end




################ 기간차 최대개수 이하로 맞추기
function slWon_giGanCha_deGesoo_eha(deGesoo)
    # ## 입력: 최대개수
    println("function slWon_giGanCha_deGesoo_eha 시작")

    nrow_df=nrow(df)

    wwa=2  ## 최초 2로 초기화
    # - 1행은 기간차 최대개수 관련 통과 인정 안함

    while true

        cca=0  ## 와번에 더할 수

        hhGiGanCha_jd=abs(df[wwa,"GIGANCHA"])

        if df[wwa,"SIGANHYUNG"]<100 && hhGiGanCha_jd>deGesoo  ## 통과시 막분

            divremVV=divrem(hhGiGanCha_jd,deGesoo)
            hhMacSu=rand(divremVV[1]:divremVV[1]+1)
            hhMacSu+=2

            ################ 기 막분
            hhBB=[df[wwa-1,"GI"],df[wwa,"GI"]]
            se_giDle=ChamBB_macboon_st_watgat(hhBB,hhMacSu,1,CHg01_soDongChi)  ## 결. 막분

            ################ 아이디 막분
            hhBB=[df[wwa-1,"ID"],df[wwa,"ID"]]
            se_idDle=ChamBB_macboon_st(hhBB,hhMacSu,2,CHg01_soDongChi)  ## 결. 막분

            ################ 에포크밀리초 막분
            hhBB=[df[wwa-1,"EPOCHMS"],df[wwa,"EPOCHMS"]]
            se_epochmsDle=ChamBB_macboon_st(hhBB,hhMacSu,2,CHg01_soDongChi)  ## 결. 막분
            se_epochmsDle=bbRoRoundBB(se_epochmsDle)

            ################ 시간형 복사
            se_sgh=repeat([df[wwa,"SIGANHYUNG"]],hhMacSu)

            ################ 에포크밀리초지구 막분
            hhBB=[df[wwa-1,"EPOCHMS_JIGU"],df[wwa,"EPOCHMS_JIGU"]]
            se_epochms_jiguDle=ChamBB_macboon_st(hhBB,hhMacSu,2,CHg01_soDongChi)  ## 결. 막분
            se_epochms_jiguDle=bbRoRoundBB(se_epochms_jiguDle)

            ################ 결. 만든것 df 에 삽 - 아이디,에포크밀리초,기 순서
            select!(df,Not("GIGANCHA"))  ## 기간차 삭제

            dfHu=DataFrame()

            ################ 20250123 이전
            """
            insertcols!(dfHu,"ID"=>copy(se_idDle[2:end-1]))
            insertcols!(dfHu,"EPOCHMS"=>copy(se_epochmsDle[2:end-1]))
            insertcols!(dfHu,"GI"=>copy(se_giDle[2:end-1]))
            insertcols!(dfHu,"SIGANHYUNG"=>copy(se_sgh[2:end-1]))
            insertcols!(dfHu,"EPOCHMS_JIGU"=>copy(se_epochms_jiguDle[2:end-1]))

            cca=length(se_idDle[2:end-1])
            """

            ################ 20250123 이후
            bb=copy(se_idDle[2:end-1])
            dfHu_ID=bbRoRoundIntBB(bb,0)

            bb=copy(se_epochmsDle[2:end-1])
            dfHu_EPOCHMS=bbRoRoundIntBB(bb,0)

            bb=copy(se_giDle[2:end-1])
            dfHu_GI=bbRoRoundIntBB(bb,0)

            bb=copy(se_sgh[2:end-1])
            dfHu_SIGANHYUNG=bbRoRoundIntBB(bb,0)

            bb=copy(se_epochms_jiguDle[2:end-1])
            dfHu_EPOCHMS_JIGU=bbRoRoundIntBB(bb,0)

            ############
            insertcols!(dfHu,"ID"=>dfHu_ID)
            insertcols!(dfHu,"EPOCHMS"=>dfHu_EPOCHMS)
            insertcols!(dfHu,"GI"=>dfHu_GI)
            insertcols!(dfHu,"SIGANHYUNG"=>dfHu_SIGANHYUNG)
            insertcols!(dfHu,"EPOCHMS_JIGU"=>dfHu_EPOCHMS_JIGU)

            cca=length(se_idDle[2:end-1])

            append!(df,copy(dfHu))
            sort!(df,"ID")

            slWon_giGanCha()

            if wwa%11==0

                println("wwa=$wwa 삽 성공")
            end
        end

        ################## 와번 관리부
        nrow_df+=cca

        wwa+=cca
        wwa+=1

        if wwa>nrow_df

            break
        end
    end

    println("function slWon_giGanCha_deGesoo_eha 끝")
end




############
function slWon_giRoundInt()
    println("function slWon_giRoundInt() 시작")

    giDle=Any[0 for i in 1:nrow(df)]

    # @threads for ffa in 1:nrow(df)
    for ffa in 1:nrow(df)

        hhGi=df[ffa,"GI"]
        roundDoin=Int(round(hhGi))
        giDle[ffa]=roundDoin  ## 결. 붙이기.
    end

    ################ 삽
    colEreum="GI"
    dfColWcVV=dfColWc(df,colEreum)

    select!(df,Not("GI"))  ## 기존 에포크밀리초 컬럼 삭제 재정비

    insertcols!(df,dfColWcVV,"GI"=>giDle)  ## 종. 프레임으로.

    println("function slWon_giRoundInt() 끝")
end




################ 참평닻100 돌변화발생 - 참평닻3_100 을 말 함.
# # 1행부터 변발 발생 유 할 수 있음. 자료고 태초시는 무 이고.
function slWon_Cpd3_gan_dolBhBsWaColSab(Cpd3_gan::String)
    # ## 입력: Cpd3_gan-"CPD3_100"
    println(pyosic)
    println("function slWon_Cpd3_gan_dolBhBsWaColSab() 시작")

    bhBsDle=repeat([0],nrow(df))

    ###### 1행 처리
    if sl_woncheon_idSu==0  ## 자료고 태초시

        bhBsDle[1]=0  ## 보편1행일

    else  ## 자료고 태초 아닐시

        hhBhBs=0

        if df_sl_woncheon_macHeng[1,"GI"]<=df_sl_woncheon_macHeng[1,Cpd3_gan] &&
            df[1,"GI"]>df[1,Cpd3_gan]

            hhBhBs=1

        elseif df_sl_woncheon_macHeng[1,"GI"]>=df_sl_woncheon_macHeng[1,Cpd3_gan] &&
            df[1,"GI"]<df[1,Cpd3_gan]

            hhBhBs=-1
        end

        bhBsDle[1]=hhBhBs  ## 보편1행일
    end

    ###### 2행부터
    # @threads for ffa in 2:nrow(df)
    for ffa in 2:nrow(df)

        hhBhBs=0  ## 보편처리일

        if df[ffa-1,"GI"]<=df[ffa-1,Cpd3_gan] && df[ffa,"GI"]>df[ffa,Cpd3_gan]

            hhBhBs=1

        elseif df[ffa-1,"GI"]>=df[ffa-1,Cpd3_gan] && df[ffa,"GI"]<df[ffa,Cpd3_gan]

            hhBhBs=-1
        end

        bhBsDle[ffa]=hhBhBs  ## 결.
    end
    ## bhBsDle 는 df의 행 길이 만큼의 원소를 갖는다. [0,0,0,1,0,0,0,0,-1,0,0,...] 이런식.
    # 1행은 무조건 0 임.

    colEreum=Cpd3_gan*"_DOLBHBS"

    insertcols!(df,colEreum=>bhBsDle)  ## 결. 프레임으로.
    # 이 컬럼이 dfGaji 에서 중요함. 회전, 산출의 기준이 됨.

    println("function slWon_Cpd3_gan_dolBhBsWaColSab() 끝")
end




################ 평기울기울기 컬럼 df 에 삽 함축 - 앞2행 입력해야 하니까 따로 만듦.
function slWon_dfRo_pgGggByul_dfSab(desangCpdColEreum)
    println(pyosic)
    println("function slWon_dfRo_pgGggByul_dfSab(desangCpdColEreum) 시작")

    # ## 입력: desangCpdColEreum-"CPD3_100" 이런거.
    dfAb2Heng=DataFrame()

    if sl_woncheon_idSu==0  ## 자료고 태초시

        append!(dfAb2Heng,copy(df[1:1,[desangCpdColEreum]]))
        append!(dfAb2Heng,copy(df[1:1,[desangCpdColEreum]]))  ## 짜가 2번 반복

    else  ## 자료고 태초 아닐시

        append!(dfAb2Heng,copy(df_sl_woncheon_macJ1Heng))
        append!(dfAb2Heng,copy(df_sl_woncheon_macHeng))
    end

    dfRo_pgGggByul_dfSab(dfAb2Heng,df,desangCpdColEreum)

    println("function slWon_dfRo_pgGggByul_dfSab(desangCpdColEreum) 끝")
end




################ 평기울기울기 컬럼 df 에 삽 함축 - 앞2행 입력해야 하니까 따로 만듦.
function slWon_dfRo_pgGggBiBbyul_dfSab(desangCpdColEreum)
    println(pyosic)
    println("function slWon_dfRo_pgGggBiBbyul_dfSab(desangCpdColEreum) 시작")

    # ## 입력: desangCpdColEreum-"CPD3_100" 이런거.
    dfAb2Heng=DataFrame()

    if sl_woncheon_idSu==0  ## 자료고 태초시

        append!(dfAb2Heng,copy(df[1:1,[desangCpdColEreum]]))
        append!(dfAb2Heng,copy(df[1:1,[desangCpdColEreum]]))  ## 짜가 2번 반복

    else  ## 자료고 태초 아닐시

        append!(dfAb2Heng,copy(df_sl_woncheon_macJ1Heng))
        append!(dfAb2Heng,copy(df_sl_woncheon_macHeng))
    end

    dfRo_pgGggBiBbyul_dfSab(dfAb2Heng,df,desangCpdColEreum)

    println("function slWon_dfRo_pgGggBiBbyul_dfSab(desangCpdColEreum) 끝")
end




################ 첫행 재설정 - 원천고의 경우 기존 원천이 100고유번 까지 있으면
# 새로운 원천 이전 대상인 df는 90~200고유번까지 있는 것을 가정한다. 그러므로 100+1:200 고유번까지 df를 추리는 작업
# 앞의 행들(90~100)을 지우고 첫행을 재설정하는 작업이 필요하다. # 보편파견부.
# 찌글 했으니까 완전히 일치하는 곳을 찾을 순 없을테고, 전 세계에서 로 자료고 시는 날 시작부터 날 막까지 끊긴
# 자료가 로 되기 때문에 자료고의 막행의 에포크 초과를 찾으면 된다.
function slWon_epochms_jigu_ro_chutHengJe()
    println(pyosic)
    println("function slWon_epochms_jigu_ro_chutHengJe() 시작")

    ## global sl_woncheon_idSu - 이 값이 1이상일때 df_sl_woncheon_macHeng 은 반드시 존재함.

    if sl_woncheon_idSu>=1  ## 자료고 최초가 아니라면 - 자료고 최초시 첫행재설정 불필요.

        goMacEpochms=df_sl_woncheon_macHeng[1,"EPOCHMS_JIGU"]

        df_hengBunChatgiVV=df_hengBunChatgi(df,"EPOCHMS_JIGU",">",goMacEpochms,1,1)  ## 초과 찾음

        hh_ce_bun=df_hengBunChatgiVV[1,"CEHENGBUN"]
      
        global df=copy(df[hh_ce_bun:end,:])  ## 결. 첫행 재설정. 앞의 행들 자르기.
    end

    println("function slWon_epochms_jigu_ro_chutHengJe() 끝")
end




################ 막행을 개장일 막시간과 일치하도록 자르기 - 특히 접합고는 원천에서 이래야만 순환이 됨.
# df를 거꾸로 읽다가 개장일의 최초 시간인 17시 정각 미만이 되면 찾음.
# 16시~17시는 비어 있어야 하는 시간이기 때문에 찾아짐.
function slWon_epochms_sbc_ro_macHengJe()
    println(pyosic)
    println("function slWon_epochms_sbc_ro_macHengJe() 시작")

    ################ 손잡이들
    ilMacSbc=(16,0,0)  ## 손잡이 - 일막시분초
    ilMacSbcJwa1=SbcDum(ilMacSbc,-1,[0,20+1,0])  ## 손잡이 20분 좌로 인정

    ceDfmacBun=0  ## 초기화일

    for ffa in nrow(df):-1:1

        hhSbc=df[ffa,"Sbc"]

        if sbcKeuJac(ilMacSbcJwa1,hhSbc)==2 && sbcKeuJac(hhSbc,(17,0,0))==2

            ceDfmacBun=ffa
            break
        end
    end

    # println("nrow(df)=$(nrow(df)) / ceDfmacBun=$ceDfmacBun")
    global df=copy(df[1:ceDfmacBun,:])  ## 찾은으로 뒤쪽행 자르기

    println("function slWon_epochms_sbc_ro_macHengJe() 끝")
end




################ 원아이디 여기서 부여
function slWon_won_id()
    println(pyosic)
    println("function slWon_won_id() 시작")

    won_idDle=[i for i in sl_woncheon_macId_Daeum:sl_woncheon_macId_Daeum+nrow(df)-1 ]
    # ## 원아이디들 - 실원천고 막아이디 다음번부터 재부여

    insertcols!(df,1,"WON_ID"=>won_idDle)

    println("function slWon_won_id() 끝")
end




################ 로고전 df 불필요 컬럼 삭제
function slWon_df_colDle_sac()
    println(pyosic)
    println("function slWon_df_colDle_sac() 시작")

    select!(df,Not("ID"))
    select!(df,Not("Sbc"))
    select!(df,Not("GIGANCHA"))

    println("function slWon_df_colDle_sac() 끝")
end




############
function slWon_dfGoJun_df_epochms_jigu_colWcMacSung()

    hh_epochms_jigu=copy(df[:,"EPOCHMS_JIGU"])

    select!(df,Not("EPOCHMS_JIGU"))

    insertcols!(df,"EPOCHMS_JIGU"=>hh_epochms_jigu)
end




################ 현 대양에서 쓰던 df 를 이후 대양들에 보내기 위해 df 앞쪽 확장
function slWon_jundal_dfSung()
    # ## 자료고 태초 아닌 일반갈래시만 통과한다.
    # # 2021년 5월 23일: 100비유에서 접합고 90까지, 날고도 90까지 기록돼 있다. 현재 접합고 대양이
    # 순환 시작할 때는 이하최대시접합인 80부터 원천고를 읽는다. 날고도 날고의 막시원아이디부터 원천고를 읽는데
    # 그게 80부터다. 왜냐면 날고의 기록 끝은 90이니까 시원아이디는 하루 10 전인 80이기 때문이다.
    # 2. 100 비유에서 50부터 읽어서 df 앞에 합친다.
    println("slWon_jundal_dfSung() 시작")

    global df_won=copy(df)

    if sl_nal_idSu>=1  ## 일반갈래 - 날고에 깔린이 있을 시.

        nal_macId_ppelSu=10

        if ChamGoEreum=="ChamGo_jjOilCs" || ChamGoEreum=="ChamGo_jjGoldCs"

            nal_macId_ppelSu=6

        elseif ChamGoEreum=="ChamGo_jjEuroCs"

            nal_macId_ppelSu=6
        end

        df_nalGo_macJ1SiWonId=
        ChamGoRoDf(CHg01_sl_nalGoEreum,sl_nal_macId-nal_macId_ppelSu,"<=","NAL_ID","<=",sl_nal_macId-nal_macId_ppelSu)  
        # ## 원천고에서 이 지점 이상 끝까지 수입함.
        # 충분히 앞을 확보하려고 sl_nal_macId-3 했음. 그러면 100비유에서 50부터 읽는 것임.
        # 일 아이디 기준에서 -3 이니까 충분히 전이 맞음.
        # 2.
        # -3 을 -1로 바꿈. 그러면 100비유에서 70부터 읽는 것임.
        # 3.
        # 100 비유에서 모든 세계를 100(가지고는 98)까지 기록하기로 했다. 
        # 그래서 -4가 충분한 수가 싶어서, 50 이니까, 그렇게 했다.

        df_ab=
        ChamGoRoDf(CHg01_sl_woncheonGoEreum,
        df_nalGo_macJ1SiWonId[1,"SI_WON_ID"],"<=","WON_ID","<",df[1,"WON_ID"])
        # 원천고의 df 가 100~1000까지 있는데, 80~100까지가 df_ab에 배치된.
        # - 날고는 90까지 로자료고 되는데 90의 시작은 80이니까 시원아이디는 80부터임.

        append!(df_ab,copy(df))
        global df=copy(df_ab)  ## 종. 새로운 df 탄생.

        println("global df=df_ab  ## 종. 새로운 df 탄생.")
    end

    println("slWon_jundal_dfSung() 끝")
end




############
function slWon_ibDf_won_id_oryuMooU(ib_df)

    oryuMooU=0  ## 오류 무 0 부여

    for ffa in 2:nrow(ib_df)

        hh_won_id_dulCha=ib_df[ffa,"WON_ID"]-ib_df[ffa-1,"WON_ID"]

        if hh_won_id_dulCha !=1
            # ## 차가 1이 아니라면

            oryuMooU=1  ## 오류 유 1 부여
        end
    end

    return oryuMooU
end




############
function slWon_jundal_dfSung_hoo_dfHengSu_hwacin()
    println("slWon_jundal_dfSung_hoo_dfHengSu_hwacin 시작")

    slWon_dfHengSu_hwacin=0

    oryuMooU=slWon_ibDf_won_id_oryuMooU(df)

    if oryuMooU==0 && nrow(df)==df[end,"WON_ID"]-df[1,"WON_ID"]+1
        # ## 행수가 같다면, 맞다면 통과.

        slWon_dfHengSu_hwacin=1004  ## 확인된 1004 부여
    end

    println("slWon_jundal_dfSung_hoo_dfHengSu_hwacin 끝")
    return slWon_dfHengSu_hwacin
end

