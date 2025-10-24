

"""
원천고 만으로 이 대양의 df 가 생성된다. 날고가 100비유에서 90까지 기록돼 있는데 하루가 10이니
날고 막행의 시원아이디는 80지점에 해당한다. 바로 그 지점부터 원천고를 읽기 시작한다.
원천고를 끝까지 읽어 df 를 생성한다. 그러므로 기준인 df 는 80~1000까지 배치된다.

그 df 만으로 프레임 날 dfNal 이 최초 생성된다. 최초 생성되는 함축에서 여러 컬럼들도 한번에 생성된다.
그러므로 프레임 날은 80~1000까지 구해지는 것이다. 그런데 1000까지는 구해지나 막행(1일치)은 짜가로
구해진다. 그 후 유전자 함축에서도 80~1000까지 구해지는데 막행(1일치)은 충전재 처리로 구해진다.
그러므로 이 대양 막판에 막행재를 1행(하루치) 해야 한다.

2021년 5월 23일: 100비유에서 접합고 90까지, 날고도 90까지 기록돼 있다. 현재 접합고 대양이
순환 시작할 때는 이하최대시접합인 80부터 원천고를 읽는다. 날고도 날고의 막시원아이디부터 원천고를 읽는데
그게 80부터다. 왜냐면 날고의 기록 끝은 90이니까 시원아이디는 하루 10 전인 80이기 때문이다.

2022년 9월 2일. 오후 5시28분. - copy 점검 완료.
"""




function slNal_si_geuDle()  ## 시원아이디, 시요일, 쫑시고저종
    # 입력되는 df가 1000만큼 있을텐데 그러면 이 함축도 1000까지 구해진다.
    # 막행은 꼭 대입되는데 짜가이다. 그래서 날고 대양 후반에서 막행재가 필요하다.
    # 앞선 가지고, 접합고가 모두 df 1000 보다 짧게 기록돼 있기도 하다.
    # 원천고인 df 입력만으로 결과냄. 로고할 프레임 날 최초 생성.
    # 흐름: df 가 1000까지 있으면 이 함축에서는 1000까지 구해는 짐. 그러나 막판 10(1일치)은 짜가임.
    println("slNal_si_geuDle() 시작")

    global dfNal=DataFrame()  ## 프레임 날 최초생성 - 일시작 2회차때부터 기록시작. 2회차때 1회에.

    #################### 초기화 - 이 초기화 처리 때문에 dfNal 을 자료고로 할때 첫행재를 해야 할 수 있음.
    hhSiYoil=1004
    ###### 시고저종 초기화일
    hoiCha=0
    ffa=1
    hhSi=df[ffa,"GI"]
    hhGo=df[ffa,"GI"]
    hhJu=df[ffa,"GI"]

    #### hhJong 최초 부여
    if sl_nal_idSu==0  ## 자료고 태초시

        hhJong=df[ffa,"GI"]  ## 종 짜가로 초기화

    else  ## 자료고 태초 아닐 시
      
        df_gi=
        ChamGoRoDf(CHg01_sl_woncheonGoEreum,
        df[1,"WON_ID"]-1,"<=","WON_ID","<=",df[1,"WON_ID"]-1)

        hhJong=df_gi[1,"GI"]  ## 종 진으로 초기화
    end

    siWonIdDle=Vector()
    macSiWonIdDle=Vector()
    siYoilDle=Vector()
    jjong_sgjjDle=Vector()
    gagamBongDleDle=Vector()

    hhSiWonId=nothing
    hhJjongGab=nothing
    hhSiJacHengBun=1
    haru_gagamBongDle=Vector()

    #################### 본격
    for ffa in 1:nrow(df)

        #################### 일시원 - 일이 시작되는 시점에 할일들
        if df[ffa,"SIGANHYUNG"]>=100 || ffa==nrow(df)  ## 일이 시작되는 모든 경우 와 df 막행시
            # - df 의 최초행은 사실상 일 시작이다.
            hoiCha+=1

            ###### 결. 기록
            if hoiCha>=2  ## 1회차 초과라면 - 회차변발시 직전회차 기록방식이니까. 2회차시 1회차 기록.
                # ffa==1행 일때도 일시 시작되는 모든 경우를 통과하는데 그때는 기록되면 안됨.
                # 그래서 hoiCha>=2 임.

                ######################
                push!(siWonIdDle,hhSiWonId)  ## 결. 붙이기. 갱신되기전 붙이기니까 전값임.

                ######################
                if ffa !=nrow(df)

                    push!(macSiWonIdDle,df[ffa-1,"WON_ID"])  ## 결. 붙이기.

                elseif ffa==nrow(df)

                    push!(macSiWonIdDle,df[ffa,"WON_ID"])  ## 결. 붙이기.
                end

                ######################
                push!(siYoilDle,hhSiYoil)  ## 결. 붙이기. 갱신되기전 붙이기니까 전값임.
                # 최초행은 대체로 1004 붙음.

                if ffa !=nrow(df)

                    ######################
                    jjong_sgjj=[hhSi-hhJjongGab,hhGo-hhJjongGab,hhJu-hhJjongGab,hhJong-hhJjongGab]
                    # ## 결. 쫑시고저종 산출. 갱신되기전 붙이기니까 전값임.
                    push!(jjong_sgjjDle,copy(jjong_sgjj))  ## 결. 붙이기.

                    ######################
                    push!(gagamBongDleDle,copy(haru_gagamBongDle))

                elseif ffa==nrow(df)

                    ######################
                    #################### 매회갱신
                    if df[ffa,"GI"]>=hhGo

                        hhGo=df[ffa,"GI"]
                    end

                    if df[ffa,"GI"]<=hhJu

                        hhJu=df[ffa,"GI"]
                    end

                    hhJong=df[ffa,"GI"]

                    jjong_sgjj=[hhSi-hhJjongGab,hhGo-hhJjongGab,hhJu-hhJjongGab,hhJong-hhJjongGab]
                    # ## 결. 쫑시고저종 산출. 갱신되기전 붙이기니까 전값임.
                    push!(jjong_sgjjDle,copy(jjong_sgjj))  ## 결. 붙이기.

                    ######################
                    #################### 가감봉
                    if ffa==1

                        hhGagamBongGab=0
                    else

                        hhGagamBongGab=df[ffa,"GI"]-df[ffa-1,"GI"]
                    end
                    
                    push!(haru_gagamBongDle,hhGagamBongGab)

                    push!(gagamBongDleDle,copy(haru_gagamBongDle))
                end
            end

            ###### 쫑값 갱신
            hhJjongGab=hhJong  ## 이때만 갱신.
            # hhJong 매회갱신 이전이니까 직전봉의(ffa-1 의) 종값임.

            ###### 시원아이디 갱신
            hhSiWonId=df[ffa,"WON_ID"]

            ###### 시요일 갱신
            hhDt=Dates.epochms2datetime(df[ffa,"EPOCHMS"])
            hhSiYoil=Dates.dayofweek(hhDt)

            ###### 시시작행번 갱신
            hhSiJacHengBun=ffa

            ###### 시고저종 초기처리
            hhSi=df[ffa,"GI"]
            hhGo=df[ffa,"GI"]
            hhJu=df[ffa,"GI"]
            hhJong=df[ffa,"GI"]

            haru_gagamBongDle=Vector()  ## 초기화
        end

        #################### 매회갱신
        if df[ffa,"GI"]>=hhGo

            hhGo=df[ffa,"GI"]
        end

        if df[ffa,"GI"]<=hhJu

            hhJu=df[ffa,"GI"]
        end

        hhJong=df[ffa,"GI"]

        #################### 가감봉
        if ffa==1

            hhGagamBongGab=0

        else

            hhGagamBongGab=df[ffa,"GI"]-df[ffa-1,"GI"]
        end

        push!(haru_gagamBongDle,hhGagamBongGab)
    end

    #################### 종. 프레임으로.
    insertcols!(dfNal,"SI_WON_ID"=>siWonIdDle)
    insertcols!(dfNal,"MACSI_WON_ID"=>macSiWonIdDle)
    insertcols!(dfNal,"SI_YOIL"=>siYoilDle)
    insertcols!(dfNal,"JJONG_SGJJ"=>jjong_sgjjDle)
    insertcols!(dfNal,"GAGAM_BONG"=>gagamBongDleDle)  ## 로고무 컬럼 가감봉 삽 - 1행==[+0,+2,+1,-2,-3,+1,-1,...]
    ## dfNal 의 행수는 df 에서 날 시작 지점의 수와 일치한다.
    ## 100비유: df 가 원천고 80~1000까지이니까, df 로만 구해지는 프레임 날도 80~1000까지 구해져 있다.
    # 그런데 990까지는 진짜지만 막판 1일치 10은 짜가다.
    # # 최초 초기화시 종값이 df 1행의 직전을 고를 읽어 초기화 하므로 진이다.
    # 그러므로 dfNal "JJONG_SGJJ" 도 1행부터 진이다.

    println("slNal_si_geuDle() 끝")
end




function slNal_nal_id()  ## 프레임 날 아이디부여 -
    # 프레임 날의 아이디는 여기서부터 날고 자료고에 대응되어 부여된다.
    # 추후 아이디 재 할 필요 없음.
    # # 프레임 날과 conn 입력 만으로 순환.
    println("slNal_nal_id() 시작")

    if sl_nal_idSu==0  ## 특수갈래 - 자료고 태초시. 날고가 태초시.

        nalIdDle=[i for i in 1:nrow_dfNal]  ## 이때만 [1,2,3,4,5,...]

    elseif sl_nal_idSu>=1  ## 일반갈래 - 날고가 깔렸을시.
      
        dfDocNalId=
        ChamGoRoDf(CHg01_sl_nalGoEreum,
        dfNal[1,"SI_WON_ID"],"<=","SI_WON_ID","<=",dfNal[1,"SI_WON_ID"])
        # ## 프레임 날의 첫행을 날고에 맞춤.

        nalIdDle=[i for i in dfDocNalId[1,"NAL_ID"]:dfDocNalId[1,"NAL_ID"]+(nrow_dfNal-1)]
        # ## 이때는 [125,126,127,...]
        ## 프레임 날은 80부터 산출돼 있고, 기존 자료고 날고에는 90까지 기록돼 있다.
        # 그러므로 80지점의 자료고 날고 아이디를 구하는 쿼리는 반드시 찾아진다.
    end

    insertcols!(dfNal,1,"NAL_ID"=>nalIdDle)  ## 결. 프레임으로.
    # 프레임 날의 첫 아이디는 일반갈래시 1이 아님.

    println("slNal_nal_id() 끝")
end




function slNal_jjong_ePyung(ehaMetbong)
    # ## 이하몇봉- 날고 준 포함이하 몇봉의 이평을 구할 거냐. # 16봉으로 하기로 함.
    println("slNal_jjong_ePyung(ehaMetbong) 시작")

    #################### 목적 프레임 마련
    if sl_nal_idSu==0  ## 자료고 태초시

        df_nalGo_jjong_sgjj=copy(dfNal[:,["NAL_ID","JJONG_SGJJ"]])  ## 목적 프레임 마련 완료

    else  ## 자료고 태초 아닐 시

        hhDocJacBun=dfNal[1,"NAL_ID"]-(ehaMetbong-1)

        if hhDocJacBun<1

            hhDocJacBun=1
        end
     
        df_nalGo_jjong_sgjj=
        ChamGoRoDf(CHg01_sl_nalGoEreum,hhDocJacBun,"<=","NAL_ID","<",dfNal[1,"NAL_ID"])
        # ## 목적 프레임- 앞쪽 일 아이디, 쫑시고저종만 깔린 날고에서 수입
        select!(df_nalGo_jjong_sgjj,"NAL_ID","JJONG_SGJJ")

        ############
        df_hengBunChatgiVV=df_hengBunChatgi(dfNal,"NAL_ID",">",df_nalGo_jjong_sgjj[end,"NAL_ID"],1,1)

        hhDf=copy(dfNal[df_hengBunChatgiVV[1,"CEHENGBUN"]:end,["NAL_ID","JJONG_SGJJ"]])

        append!(df_nalGo_jjong_sgjj,copy(hhDf))  ## 목적 프레임 마련 완료  
    end

    #################### 목적 프레임 마련 후 - 목적 프레임에 고,저 이평 컬럼 생성
    df_jjong_sgjjRo_pullin_sgjjDle_sab(df_nalGo_jjong_sgjj)  ## 시,고,저,종 컬럼 마련
    nrow_df_nalGo_jjong_sgjj=nrow(df_nalGo_jjong_sgjj)

    goEpyungDle=zeros(nrow_df_nalGo_jjong_sgjj)
    juEpyungDle=zeros(nrow_df_nalGo_jjong_sgjj)

    # @threads for ffa in 1:nrow_df_nalGo_jjong_sgjj
    for ffa in 1:nrow_df_nalGo_jjong_sgjj

        ###### 배열 마련 번호 마련
        if ffa<=ehaMetbong

            jacHengBun=1
            macHengBun=ffa

        else

            jacHengBun=ffa-(ehaMetbong-1)
            macHengBun=ffa
        end

        ###### 본격 - 이평 산출 붙이기
        hhChoorinBB=copy(df_nalGo_jjong_sgjj[jacHengBun:macHengBun,"GO"])
        meanVV=mean(hhChoorinBB)
        goEpyungDle[ffa]=meanVV  ## 결. 쫑고값 이평 붙이기.

        hhChoorinBB=copy(df_nalGo_jjong_sgjj[jacHengBun:macHengBun,"JU"])
        meanVV=mean(hhChoorinBB)
        juEpyungDle[ffa]=meanVV  ## 결. 쫑저값 이평 붙이기.
    end

    insertcols!(df_nalGo_jjong_sgjj,"JJONG_GO_EPYUNG"=>goEpyungDle)
    insertcols!(df_nalGo_jjong_sgjj,"JJONG_JU_EPYUNG"=>juEpyungDle)

    #################### 목적 프레임에 고,저 이평 컬럼 생성 후 - dfNal 로 맞게 옮기기
    dfHengBunVV=dfHengBun(df_nalGo_jjong_sgjj,"NAL_ID",dfNal[1,"NAL_ID"],1)
    # ## 자료고 태초시엔 df_nalGo_jjong_sgjj=dfNal 이 되므로 dfNal 의 1행 것을 찾는게 반드시 찾아짐.

    choorinEpyungBB=copy(df_nalGo_jjong_sgjj[dfHengBunVV:end,"JJONG_GO_EPYUNG"])
    insertcols!(dfNal,"JJONG_GO_EPYUNG"=>choorinEpyungBB)  ## 종. 프레임 날로 삽.

    choorinEpyungBB=copy(df_nalGo_jjong_sgjj[dfHengBunVV:end,"JJONG_JU_EPYUNG"])
    insertcols!(dfNal,"JJONG_JU_EPYUNG"=>choorinEpyungBB)  ## 종. 프레임 날로 삽.
    ## dfNal 의 "JJONG_GO_EPYUNG","JJONG_JU_EPYUNG" 는 1행부터 진이다.

    println("slNal_jjong_ePyung(ehaMetbong) 끝")
end




function slNal_pgb()  ## 평값비율
    println("slNal_pgb() 시작")

    go_pgbDle=zeros(nrow_dfNal)
    ju_pgbDle=zeros(nrow_dfNal)

    #################### 1행 짜가 채우기
    ffa=1
    hhJjongGab=dfNal[ffa,"JJONG_SGJJ"][2]  ## 고값
    hh_ePyung=dfNal[1,"JJONG_GO_EPYUNG"]  ## 이평
    hhPgb=hhJjongGab/hh_ePyung  ## 결. 평값비 구한.

    go_pgbDle[ffa]=hhPgb  ## 결. 붙이기. 평값비들.

    hhJjongGab=dfNal[ffa,"JJONG_SGJJ"][3]  ## 저값
    hh_ePyung=dfNal[1,"JJONG_JU_EPYUNG"]  ## 이평
    hhPgb=hhJjongGab/hh_ePyung  ## 결. 평값비 구한.

    ju_pgbDle[ffa]=hhPgb  ## 결. 붙이기. 평값비들.

    #################### 2행 이상 진 채우기
    # @threads for ffa in 2:nrow_dfNal
    for ffa in 2:nrow_dfNal

        hhJjongGab=dfNal[ffa,"JJONG_SGJJ"][2]  ## 고값
        hh_ePyung=dfNal[ffa-1,"JJONG_GO_EPYUNG"]  ## 이평
        hhPgb=hhJjongGab/hh_ePyung  ## 결. 평값비 구한.

        go_pgbDle[ffa]=hhPgb  ## 결. 붙이기. 평값비들.

        hhJjongGab=dfNal[ffa,"JJONG_SGJJ"][3]  ## 저값
        hh_ePyung=dfNal[ffa-1,"JJONG_JU_EPYUNG"]  ## 이평
        hhPgb=hhJjongGab/hh_ePyung  ## 결. 평값비 구한.

        ju_pgbDle[ffa]=hhPgb  ## 결. 붙이기. 평값비들.
    end

    #################### 결.
    insertcols!(dfNal,"JJONG_GO_PGB"=>go_pgbDle)  ## 1행은 짜가고 2행부터 진인
    insertcols!(dfNal,"JJONG_JU_PGB"=>ju_pgbDle)  ## 1행은 짜가고 2행부터 진인

    println("slNal_pgb() 끝")
end




function slNal_nal_simi_yucryang(ib_soDongChi)
    # ## 역량 - 한 가지 준. 역량예비1=(시꼭의 세로차절대/시꼭 거리)*시꼭의 세로차절대. 음양양.
    # 역량예비2=((꼭지봉 꼭지치)-(꼭지봉 '비교크기-1'봉전의 꼭지치) )/
    # (시작봉 시작치-(시작봉 '비교크기-1'봉전의 시작치) ). 음양유.
    # 역량=역량예비1*역량예비2. 위 괄호중 0이 나올시 소동치의 1000분 1치로 대체한다.
    # 역량=음양양*음양유. 그래서 음양유. 같은 향이 연속되면 음양양이고, 향이 꺾였으면 음양음 이 된다.
    #
    # # 이 함축 - 대상: 이하 5봉. 비교크기: 5.
    # 그래서 10번 봉이 현봉이라고 하면 2번 봉부터 필요함. 9개 필요함. 2 3 4 5 6/6 7 8 9 10.
    # 자료고 태초시 됨.
    println("slNal_nal_simi_yucryang(ib_soDongChi) 시작")

    biGyoKeugi=5  ## 손잡이 이긴 한데 이 함축은 5만됨.

    yucryangDle=zeros(nrow_dfNal)  ## 역량들

    # @threads for ffa in 1:nrow_dfNal
    for ffa in 1:nrow_dfNal
        
        hhDocJacId=dfNal[ffa,"NAL_ID"]-8  ## 쿼리에서 읽을 시작 아이디. 2인.
        hhDocKeutId=dfNal[ffa,"NAL_ID"]-1  ## 쿼리에서 읽을 끝 아이디. 9인.
        ## 자료고 태초시 위 두 변수가 음수가 됨. 그래도 오류 안남. 아래에서 껍데기 반환.

        df_mounNalDle=
        ChamGoRoDf(CHg01_sl_nalGoEreum,hhDocJacId,"<=","NAL_ID","<=",hhDocKeutId)
        # ## 프레임 모은 일들.
        # 자료고 태초시 됨. 0×2 DataFrame 대입돼야 함. 컬럼들은 존재함.

        if df_mounNalDle==nothing

            df_mounNalDle=DataFrame(NAL_ID=[],JJONG_SGJJ=[])

        else

            select!(df_mounNalDle,"NAL_ID","JJONG_SGJJ")
        end

        dda=[dfNal[ffa,"NAL_ID"],dfNal[ffa,"JJONG_SGJJ"]]
        push!(df_mounNalDle,copy(dda))
        # ## 프레임 날의 현재행 붙여서 프레임 모은 일들 완성. # 10 붙이기.
        # 자료고 태초시 됨.

        gihwaSgjjDle=jjongSgjjDle_roGihwaSgjjDle(0,df_mounNalDle[:,"JJONG_SGJJ"])
        # ## 입력: 길이 1일시 [[시,고,저,종]] 이어야 하고 그러함.
        # # 결. 기화된 시고저종들 - (시,고,저,종) 여러개인 배열. 2부터 10까지 기화.
        # 자료고 태초시 됨. 자료고 태초시 [(시,고,저,종)] 대입됨.

        #################### 가지화 - 가지처럼 놓기
        #################### 준비
        hhDocBun=length(gihwaSgjjDle)-5

        if hhDocBun<=0

            hhDocBun=1  ## 0시 보정
        end

        jjongYgab=gihwaSgjjDle[hhDocBun][end]  ## 쫑값 마련

        if length(gihwaSgjjDle)>=5  ## 일반갈래

            hhGaji=copy(gihwaSgjjDle[end-4:end])  ## 가지처럼 놓는 대상: 현일 이하 5봉. 기화된 (시,고,저,종) 5개.

        else  ## 자료고 태초시

            hhGaji=copy(gihwaSgjjDle)
        end

        hhGaji_geumgang=gihwaSgjjDleRoGeumgang(hhGaji)  ## (-1,(x,y),(x,y),(x,y),(x,y)). 음양유.
        # 이후 금강이 기반임. 금강의 인덱스를 유념할 것. # 자료고 태초시 됨.

        goJjongCha=hhGaji_geumgang[3][2]-jjongYgab  ## 음양양.
        jjongJuCha=jjongYgab-hhGaji_geumgang[4][2]  ## 음양양.

        if goJjongCha>=jjongJuCha

            kkok=1  ## 꼭지는 고점

        else

            kkok=-1  ## 꼭지는 저점
        end

        #################### 본격
        ###### 역량예비1
        #### 시꼭세로차절대 - 음양양.
        if kkok==1

            jjongKkokSeroChaJd=goJjongCha

        elseif kkok==-1

            jjongKkokSeroChaJd=jjongJuCha
        end

        if jjongKkokSeroChaJd==0

            jjongKkokSeroChaJd=ib_soDongChi*0.0001  ## 0시 보정.
        end

        #### 시꼭 거리
        if kkok==1

            xCha=hhGaji_geumgang[3][1]-0
            yCha=goJjongCha
            jjongKkokGuri=sqrt((xCha^2)+(yCha^2))

        elseif kkok==-1

            xCha=hhGaji_geumgang[4][1]-0
            yCha=jjongJuCha
            jjongKkokGuri=sqrt((xCha^2)+(yCha^2))
        end

        if jjongKkokGuri==0

            jjongKkokGuri=ib_soDongChi*0.0001  ## 0시 보정.
        end

        #### 결. 역량예비1
        yucryangY1=(jjongKkokSeroChaJd/jjongKkokGuri)*jjongKkokSeroChaJd

        ###### 역량예비2
        if kkok==1  ## 꼭지가 고점일시

            docAbBongWc=(5-1)+(hhGaji_geumgang[3][1]-(biGyoKeugi-1))  ## 읽을앞봉위치

            if docAbBongWc<1

                docAbBongWc=1  ## 인덱싱 오류 방지 보정
            end

            yya=hhGaji_geumgang[3][2]-gihwaSgjjDle[docAbBongWc][2]  ## 결. 고점간.
            # 마련1. ((꼭지봉 꼭지치)-(꼭지봉 '비교크기-1'봉전의 꼭지치) ).

            if yya==0

                yya=ib_soDongChi*0.0001  ## 0시 보정.
            end

            docAbBongWc=(5-1)+(hhGaji_geumgang[2][1]-(biGyoKeugi-1))  ## 읽을앞봉위치

            if docAbBongWc<1

                docAbBongWc=1  ## 인덱싱 오류 방지 보정
            end

            yyb=hhGaji_geumgang[2][2]-gihwaSgjjDle[docAbBongWc][1]  ## 결.
            # 마련2. (시작봉 시작치-(시작봉 '비교크기-1'봉전의 시작치) ).
            if yyb==0

                yyb=ib_soDongChi*0.0001  ## 0시 보정.
            end

            #### 결. 역량예비2
            yucryangY2=yya/yyb

        elseif kkok==-1  ## 꼭지가 저점일시

            docAbBongWc=(5-1)+(hhGaji_geumgang[4][1]-(biGyoKeugi-1))  ## 읽을앞봉위치

            if docAbBongWc<1

                docAbBongWc=1  ## 인덱싱 오류 방지 보정
            end

            yya=hhGaji_geumgang[4][2]-gihwaSgjjDle[docAbBongWc][3]  ## 결. 저점간
            # 마련1. ((꼭지봉 꼭지치)-(꼭지봉 '비교크기-1'봉전의 꼭지치) ).
            if yya==0

                yya=ib_soDongChi*0.0001  ## 0시 보정.
            end

            docAbBongWc=(5-1)+(hhGaji_geumgang[2][1]-(biGyoKeugi-1))  ## 읽을앞봉위치

            if docAbBongWc<1

                docAbBongWc=1  ## 인덱싱 오류 방지 보정
            end

            yyb=hhGaji_geumgang[2][2]-gihwaSgjjDle[docAbBongWc][1]  ## 결.
            # 마련2. (시작봉 시작치-(시작봉 '비교크기-1'봉전의 시작치) ).

            if yyb==0

                yyb=ib_soDongChi*0.0001  ## 0시 보정.
            end

            #### 결. 역량예비2
            yucryangY2=yya/yyb
        end

        ###### 종. 역량.
        yucryang=yucryangY1*yucryangY2  ## 종. 역량. # 치 1개.

        yucryangDle[ffa]=yucryang
    end

    insertcols!(dfNal,"NAL_SIMI_YUCRYANG"=>yucryangDle)

    df_abDui_print(dfNal)
    println("slNal_nal_simi_yucryang(ib_soDongChi) 끝")
end




function slNal_dfGaji_dfJub_hwacjang_j1()
    # ## 자료고 태초시엔 무일
    println("slNal_dfGaji_dfJub_hwacjang() 시작")

    if sl_nal_idSu>=1  ## 자료고 태초 아닐 시

        chul_si_won_id=dfNal[1,"SI_WON_ID"]  ## 출발의 기준 시원아이디- 확장된 df 로부터 dfNal 이 나왔다.
        # - dfNal 1행은 100비유에서 50이다.

        #################### dfJub 확장
        df_jubBuchil=
        ChamGoRoDf(CHg01_sl_jubhabGoEreum,chul_si_won_id,"<=","SI_WON_ID","<",dfJub[1,"SI_WON_ID"])

        if df_jubBuchil !=nothing

            append!(df_jubBuchil,copy(dfJub))  ## 붙이기
            global dfJub=copy(df_jubBuchil)  ## 결. 확장 마련.
        end

        #################### dfGaji 확장
        """
        sql="SELECT GAJI_ID FROM ADC_JJOIL_TS_SL02_GAJI100 WHERE SI_WON_ID<=$chul_si_won_id "*
        "ORDER BY GAJI_ID DESC LIMIT 1;"  ## 읽을 기준 지점(아이디) 찾기
        """
        df_gga=
        ChamGoRoDf(CHg01_sl_gaji100GoEreum,chul_si_won_id-3000,"<=","SI_WON_ID","<=",chul_si_won_id)
        # ## 읽을 기준 지점(아이디) 찾기 ## 자료고 태초시 껍데기 대입됨.

        if df_gga==nothing

            hhDocGajiId=1

        else

            hhDocGajiId=df_gga[end,"GAJI100_ID"]
        end

        gyunKeugi=130  ## 평균 크기 - 가지고의 일 범위 앞을 읽어 배치할때 필요.
        # 뒤의 내유전자가 평균 크기 32이 맞춰져 있음. # 32 이었음.

        docJac_gaji_id=hhDocGajiId-gyunKeugi  ## 32개 전 번호부터 읽기

        df_gajiBuchil=
        ChamGoRoDf(CHg01_sl_gaji100GoEreum,docJac_gaji_id,"<=","GAJI100_ID","<",dfGaji[1,"GAJI100_ID"])

        if df_gajiBuchil !=nothing

            append!(df_gajiBuchil,copy(dfGaji))  ## 붙이기
            global dfGaji=copy(df_gajiBuchil)  ## 결. 확장 마련.
        end
    end
    ## dfJub은 하루치 정도인 10만큼 dfGaji 몇개 정도인 2만큼 원천에 비해 짧다. 막행재 돼 있다.

    println("slNal_dfGaji_dfJub_hwacjang() 끝")
end




function slNal_dfGaji_dfJub_hwacjang()
    # ## 자료고 태초시엔 무일
    println("slNal_dfGaji_dfJub_hwacjang() 시작")

    if sl_nal_idSu>=1  ## 자료고 태초 아닐 시

        chul_si_won_id=dfNal[1,"SI_WON_ID"]  ## 출발의 기준 시원아이디- 확장된 df 로부터 dfNal 이 나왔다.
        # - dfNal 1행은 100비유에서 50이다.

        ##########
        hhDoc_nal_id=dfNal[1,"NAL_ID"]-2  ## -2 손잡이2전 날만 
        hhDoc_nalGo=ChamGoRoDf(CHg01_sl_nalGoEreum,hhDoc_nal_id,"<=","NAL_ID","<=",hhDoc_nal_id)
        # ## 1행인
        hhDoc_nalGo_si_won_id=hhDoc_nalGo[1,"SI_WON_ID"]
        # ## dfNal 1행의 2전 날의 si_won_id 

        #################### dfJub 확장
        df_jubBuchil=
        ChamGoRoDf(CHg01_sl_jubhabGoEreum,hhDoc_nalGo_si_won_id,"<=","SI_WON_ID","<",dfJub[1,"SI_WON_ID"])

        if df_jubBuchil !=nothing

            append!(df_jubBuchil,copy(dfJub))  ## 붙이기
            global dfJub=copy(df_jubBuchil)  ## 결. 확장 마련.
        end

        #################### dfGaji 확장
        df_gajiBuchil_gaji=
        ChamGoRoDf(CHg01_sl_gaji100GoEreum,hhDoc_nalGo_si_won_id,"<=","SI_WON_ID","<",dfGaji[1,"SI_WON_ID"])

        if df_gajiBuchil_gaji !=nothing

            append!(df_gajiBuchil_gaji,copy(dfGaji))  ## 붙이기
            global dfGaji=copy(df_gajiBuchil_gaji)  
            # ## 결. 확장 마련. 2날 앞 까지만으로 추려진.
        end

        #################### df 와 dfGaji 맞추기 
        if dfGaji[1,"SI_WON_ID"]<df[1,"WON_ID"]
            # ## df 보다 dfGaji 미사가 더 길때만 통과

            df_wonBuchil=
            ChamGoRoDf(CHg01_sl_woncheonGoEreum,dfGaji[1,"SI_WON_ID"],"<=","WON_ID","<",df[1,"WON_ID"])

            select!(df,Not("JUBHYUNG"))  ## "JUBHYUNG" 컬럼 삭제

            append!(df_wonBuchil,copy(df))  ## 붙이기
            global df=copy(df_wonBuchil)  ## 결. 확장 마련.
        end
    end
    ## dfJub은 하루치 정도인 10만큼 dfGaji 몇개 정도인 2만큼 원천에 비해 짧다. 막행재 돼 있다.

    println("slNal_dfGaji_dfJub_hwacjang() 끝")
end




function slNal_ne_ujunja(ib_soDongChi)  ## 역량의 비교크기 - 손잡이. 100으로 함.
    # ## 매회 dfNal이 회전되어 배치된다. 매회 자료고를 읽어 이 함축내 프레임들을 갱신한다.
    # 먼저 한 날에서 시접합, 막접합 가지를 파악하는게 필요하므로 접합 가지 관련 프레임을 만든다.
    # 그후 가지고 관련 프레임을 만든다.
    # 가지들이 모인 각각의 프레임은 수입되어 최초 생성될때 시원아이디, 기울값길, 지레비길 컬럼을 공통적으로 가지며
    # 수입 이후 역량 만드는 함축을 통해 역량, 소모역량 컬럼을 갖게 된다. 4개 염기가 마련된 것이다.
    # 가지 1개는 4개의 염기를 가진다. 기울값길, 지레비길, 역량, 소모역량 을 갖는다.
    #
    # 이렇게 4개 염기가 준비되면 이후 본격적으로 염기서열을 정하게 된다.
    # 4개 염기 각각 직전 봉까지의 32평균 대비 이격도인 왔갔을 만들고 그 오름차순에 따라 염기서열을 정한다.
    # 그 오름차순 그대로 dna 변수에 붙인다. dna 완성이다. 이후 마침강이다.
    #
    # 정리: 가지 1개당 4개 염기를 가짐. 4개 염기는 기울값길, 지레비길, 역량, 소모역량 임.
    # 이 4개 염기가 염기서열이 정해진후 순서대로 기록된게 dna 1개임.
    # 이 dna 가 여러개 모인 dnaDle 은 가지들 갯수와 일치함.
    # 이런 dnaDle 을 유전자 라고 함. 유전자는 3개로 나뉘는데 시유전자,중유전자,막유전자임.
    # 이런 유전자(유전자단) 1개는 1일을 채움.
    #
    # # 날 범위 이하 가지들은 날 범위 내 가지들의 염기서열을 정하는데 필요하다.
    # # 입력되는 프레임 날이 1000까지 있으면 990까지 일반갈래로 구해지고 마지막 1일 10은 껍데기로 채워진다.
    println("slNal_ne_ujunja(ib_soDongChi) 시작")

    ###############
    gyunKeugi=32  ## 평균 크기 - 가지고의 일 범위 앞을 읽어 배치할때 필요
    ujunjaDle=Vector()  ## 프레임 날에 넣을

    ###############
    hh_ce_df_si_won_id_bun=1
    hh_ce_df_mac_won_id_bun=nrow(df)

    hh_ce_df_si_won_id_bun2=1
    hh_ce_df_mac_won_id_bun2=nrow(df)

    hh_ce_df_si_won_id_bunNa=1
    hh_ce_df_mac_won_id_bunNa=nrow(df)

    hh_ce_df_si_won_id_bunNa2=1
    hh_ce_df_mac_won_id_bunNa2=nrow(df)

    for ffa in 1:nrow_dfNal
        # ## 1. 특수갈래 두는 이유는 ffa+1 을 읽는 곳이 있었고 접합고가 100비유에서 90까지 기록돼 있으니 
        # 마지막 1일치는 접합고가 안 찾아지기 때문이었음.
        # 2. 이제는 hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"] 처리하였고 전 세계 100(가지고만 98)까지 산출 로고함.

        ujunjaCC=fill([],3)  ## 종결. 유전자 변수 최초 초기화.

        hhNalSiWonId=dfNal[ffa,"SI_WON_ID"]  ## 프레임일로부터 - 이상 읽을
        hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"]  ## 프레임일로부터 - 이하 읽을

        ######################### 준비강
        #################### 접합 가지산
        df_hengBunChatgiVV=df_hengBunChatgi(dfJub,"SI_WON_ID",">=",hhNalSiWonId,1,1)
        dfJub_jacDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_hengBunChatgiVV=df_hengBunChatgi(dfJub,"SI_WON_ID","<=",hhNalMacSiWonId,-1,1)
        dfJub_macDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_suibJubGo=copy(dfJub[dfJub_jacDocHengBun:dfJub_macDocHengBun,:])
        # ## 결. 함축내 프레임 df_suibJubGo 최초 생성. # 언제나 1행 또는 2행임.
        # # 자료고 태초시 찾아짐.
        nrow_df_suibJubGo=nrow(df_suibJubGo)

        #################### 역량,소모역량 마련
        yucryangDle=zeros(nrow_df_suibJubGo)
        somoDle=zeros(nrow_df_suibJubGo)

        # @threads for ffb in 1:nrow_df_suibJubGo
        for ffb in 1:nrow_df_suibJubGo

            ###### 준비
            hhSiWonId=df_suibJubGo[ffb,"SI_WON_ID"]  ## 시원아이디
            hhJjongGaji=copy(df_suibJubGo[ffb,"JJONG_GAJI"])
            hhMacSiWonId=hhSiWonId+(length(hhJjongGaji)-1)  ## 막시원아이디

            ###### 본격
            woncheonDf_won_idRo_bigyoKeugi01VV=woncheonDf_won_idRo_bigyoKeugi01(df,"WON_ID",hhSiWonId,0,
            hh_ce_df_si_won_id_bun,hh_ce_df_mac_won_id_bun)

            bigyoKeugi=woncheonDf_won_idRo_bigyoKeugi01VV[1]
            hh_ce_df_si_won_id_bun=woncheonDf_won_idRo_bigyoKeugi01VV[2]
            hh_ce_df_mac_won_id_bun=woncheonDf_won_idRo_bigyoKeugi01VV[3]

            woncheonDfRo_yucryangDoolVV=woncheonDfRo_yucryangDool(df,"WON_ID",hhSiWonId,hhMacSiWonId,bigyoKeugi,ib_soDongChi,
            hh_ce_df_si_won_id_bun2,hh_ce_df_mac_won_id_bun2)

            yucryangDool=copy(woncheonDfRo_yucryangDoolVV[1])
            # ## 결. (역량,순간역량)
            hh_ce_df_si_won_id_bun2=woncheonDfRo_yucryangDoolVV[2]
            hh_ce_df_mac_won_id_bun2=woncheonDfRo_yucryangDoolVV[3]

            yucryangDle[ffb]=yucryangDool[1]
            somoDle[ffb]=yucryangDool[2]
        end

        insertcols!(df_suibJubGo,"UJUN_YUCRYANG"=>yucryangDle)
        insertcols!(df_suibJubGo,"UJUN_SOMOYUCRYANG"=>somoDle)
        ## df_suibJubGo 행수는 대체로 2임. 가끔 1.

        #################### 일반 가지산 - 접합 가지산과 중간만 쌍둥이이고 앞쪽이 다르고, 뒤쪽이 추가돼 있음.
        # 프레임 날범위 + 그 앞의 32개 가지도 배치되는

        ###### 흐름 변수 산출
        df_suibGajiGo_heureum=nothing  ## 일종의 배치 허락 변수

        if nrow_df_suibJubGo==1  ## 시접합으로 뒤덮힌 경우

            df_suibGajiGo_heureum=0  ## df_suibGajiGo 가 0행이 되는 경우

        elseif nrow_df_suibJubGo==2  ## 시접합,막접합이 둘 다 있는 경우

            dfGaji_ceHengBun1=df_hengBunChatgi(dfGaji,"SI_WON_ID",">",df_suibJubGo[1,"SI_WON_ID"],1,1)
            dfGaji_ceHengBun2=df_hengBunChatgi(dfGaji,"SI_WON_ID","<",df_suibJubGo[2,"SI_WON_ID"],-1,1)

            if (nrow(dfGaji_ceHengBun1)>=1 && nrow(dfGaji_ceHengBun2)>=1) && 
                (dfGaji_ceHengBun2[1,"CEHENGBUN"]-dfGaji_ceHengBun1[1,"CEHENGBUN"])>=0
                # ## 2023년 11월 24일에 snp500 종목 순환 중 오류로 nrow(dfGaji_ceHengBun1) 조건 추가함.

                df_suibGajiGo_heureum=1  ## 일반갈래 - 시접합+일반가지 1개 이상+막접합 으로 날이 구성된 경우

            else

                df_suibGajiGo_heureum=0  ## df_suibGajiGo 가 0행이 되는 경우 - 시접합+막접합 으로만 날이 구성된 경우
            end
        end

        ###### 흐름 이후 df_suibGajiGo 마련
        #### 시작번
        df_hengBunChatgiVV=df_hengBunChatgi(dfGaji,"SI_WON_ID","<=",hhNalSiWonId,-1,1)
        # ## 자료고 태초시 껍데기 대입됨.

        if nrow(df_hengBunChatgiVV)==0  ## 특수갈래 - 자료고 태초시

            dfGaji_jacDocHengBun=1  ## 최초행인 1행 부여.

        elseif nrow(df_hengBunChatgiVV)==1  ## 일반 갈래

            dfGaji_jacDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]-gyunKeugi  ## 32개 전 번호부터 읽기

            if dfGaji_jacDocHengBun<1

                dfGaji_jacDocHengBun=1
            end
        end

        #### 막번
        df_hengBunChatgiVV=df_hengBunChatgi(dfGaji,"SI_WON_ID","<=",hhNalMacSiWonId,-1,1)

        if nrow(df_hengBunChatgiVV)==0  ## 특수갈래 - 자료고 태초인데 시접합+막접합 일시 등

            dfGaji_macDocHengBun=1

        elseif nrow(df_hengBunChatgiVV)==1

            dfGaji_macDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]
        end

        df_suibGajiGo=copy(dfGaji[dfGaji_jacDocHengBun:dfGaji_macDocHengBun,:])  ## 결. 함축내 프레임 df_suibGajiGo 최초 생성
        # ## 이후에 사용되는 필수 컬럼들
        # - 시원아이디-기준,쫑가지-길이 알아야 막시원아이디 아니까,쫑길-대상,지레비길-대상
        ## 자료고 태초이면서 시접합+막접합으로 뒤덮인 특수 갈래시 nrow_df_suibGajiGo==1 일 수 있음.
        # 그 외에는 무조건 대략 32개 이상임.
        # df_suibGajiGo_heureum==0 일시에도 대략 32개 이상 무조건 배치시킴. 이후 순환을 위해.
        ## 일반갈래시 df_suibGajiGo 행수는 하루치(100개)+32개 이지만, 자료고 태초시 하루치(100개)만 배치됨.
        nrow_df_suibGajiGo=nrow(df_suibGajiGo)

        #
        #################### 역량,소모역량 마련 - 접합 가지산의 그것과 일란성
        yucryangDle=zeros(nrow_df_suibGajiGo)
        somoDle=zeros(nrow_df_suibGajiGo)

        # @threads for ffb in 1:nrow_df_suibGajiGo  ## 가지들 수(100+32개 정도) 만큼 회전함
        for ffb in 1:nrow_df_suibGajiGo

            ###### 준비
            hhSiWonId=df_suibGajiGo[ffb,"SI_WON_ID"]  ## 시원아이디
            hhJjongGaji=df_suibGajiGo[ffb,"JJONG_GAJI"]
            hhMacSiWonId=hhSiWonId+(length(hhJjongGaji)-1 )  ## 막시원아이디
         
            ###### 본격
            woncheonDf_won_idRo_bigyoKeugi01VV=woncheonDf_won_idRo_bigyoKeugi01(df,"WON_ID",hhSiWonId,0,
            hh_ce_df_si_won_id_bunNa,hh_ce_df_mac_won_id_bunNa)

            bigyoKeugi=woncheonDf_won_idRo_bigyoKeugi01VV[1]
            hh_ce_df_si_won_id_bunNa=woncheonDf_won_idRo_bigyoKeugi01VV[2]
            hh_ce_df_mac_won_id_bunNa=woncheonDf_won_idRo_bigyoKeugi01VV[3]

            woncheonDfRo_yucryangDoolVV=woncheonDfRo_yucryangDool(df,"WON_ID",hhSiWonId,hhMacSiWonId,bigyoKeugi,ib_soDongChi,
            hh_ce_df_si_won_id_bunNa2,hh_ce_df_mac_won_id_bunNa2)

            yucryangDool=copy(woncheonDfRo_yucryangDoolVV[1])
            # ## 결. (역량,순간역량)
            hh_ce_df_si_won_id_bunNa2=woncheonDfRo_yucryangDoolVV[2]
            hh_ce_df_mac_won_id_bunNa2=woncheonDfRo_yucryangDoolVV[3]

            yucryangDle[ffb]=yucryangDool[1]
            somoDle[ffb]=yucryangDool[2]
        end

        insertcols!(df_suibGajiGo,"UJUN_YUCRYANG"=>yucryangDle)
        insertcols!(df_suibGajiGo,"UJUN_SOMOYUCRYANG"=>somoDle)
        ## df_suibGajiGo 에는 행이 하루치(약 100개)+32개 가 있다.

        #################### 4개 염기 평균 마련 - df_suibGajiGo 에 32개 평균 마련
        jjong_giulGabGilGyunDle=zeros(nrow_df_suibGajiGo)
        jirebi_giulGabGilGyunDle=zeros(nrow_df_suibGajiGo)
        yucryangGyunDle=zeros(nrow_df_suibGajiGo)
        sunganYucryangGyunDle=zeros(nrow_df_suibGajiGo)

        # @threads for ffb in 1:nrow_df_suibGajiGo  ## 가지들 수(100+32개 정도) 만큼 회전함
        for ffb in 1:nrow_df_suibGajiGo

            #### 배열 읽을 시작, 막번 구하기
            if ffb<gyunKeugi

                jacBun=1
                macBun=ffb

            elseif ffb>=gyunKeugi

                jacBun=ffb-(gyunKeugi-1)
                macBun=ffb
            end

            #### 본격 - 4개 염기 각각 32개 평균 구하기
            meanVV=mean(df_suibGajiGo[jacBun:macBun,"JJONG_GIULGABGIL"])
            jjong_giulGabGilGyunDle[ffb]=meanVV  ## 결.

            meanVV=mean(df_suibGajiGo[jacBun:macBun,"JIREBI_GIULGABGIL"])
            jirebi_giulGabGilGyunDle[ffb]=meanVV  ## 결.

            meanVV=mean(df_suibGajiGo[jacBun:macBun,"UJUN_YUCRYANG"])
            yucryangGyunDle[ffb]=meanVV  ## 결.

            meanVV=mean(df_suibGajiGo[jacBun:macBun,"UJUN_SOMOYUCRYANG"])
            sunganYucryangGyunDle[ffb]=meanVV  ## 결.
        end

        #### 결결. 프레임 배치.
        insertcols!(df_suibGajiGo,"JJONG_GIULGABGIL_32GYUN"=>jjong_giulGabGilGyunDle)
        insertcols!(df_suibGajiGo,"JIREBI_GIULGABGIL_32GYUN"=>jirebi_giulGabGilGyunDle)
        insertcols!(df_suibGajiGo,"UJUN_YUCRYANG_32GYUN"=>yucryangGyunDle)
        insertcols!(df_suibGajiGo,"UJUN_SOMOYUCRYANG_32GYUN"=>sunganYucryangGyunDle)
        ## df_suibGajiGo 에는 행이 하루치(약 100개)+32개 가 있다.
        ## df_suibJubGo, df_suibGajiGo 에는
        # 시원아이디 그리고 기울값길,지레비길,역량,소모역량 4개 염기(컬럼)가 있다.
        # 중심인 df_suibGajiGo 에는 그 각각의 32평균 컬럼도 있다.

        #
        ######################### 본격강 - 염기서열 결정되어 각 가지의 유전자 생성 배치되는
        #################### 접합 가지산 - 시원아이디로 df_gaji 에서 기반 전1 32평균을 찾는다.
        dnaDle=fill([],nrow_df_suibJubGo)

        # @threads for ffb in 1:nrow_df_suibJubGo
        for ffb in 1:nrow_df_suibJubGo

            # ## df_suibJubGo 행수는 대체로 2임. 가끔 1.
            yumgiDle=Vector()
            j1_32GyunDle=Vector()

            ###### 염기들 순서대로 붙이기
            push!(yumgiDle,[1,df_suibJubGo[ffb,"JJONG_GIULGABGIL"]])
            push!(yumgiDle,[2,df_suibJubGo[ffb,"JIREBI_GIULGABGIL"]])
            push!(yumgiDle,[3,df_suibJubGo[ffb,"UJUN_YUCRYANG"]])
            push!(yumgiDle,[4,df_suibJubGo[ffb,"UJUN_SOMOYUCRYANG"]])
            ## 염기들 4개행 된 - 1개행 (2,14.141414)

            ###### 전1 32평균 순서대로 붙이기 - 현 대상의 전1 32평균이 배치됨.
            bigyoGab=df_suibJubGo[ffb,"SI_WON_ID"]  ## 배치된 시접합의 시원아이디
            df_hhBumoGaji=df_hengBunChatgi(df_suibGajiGo,"SI_WON_ID","<=",bigyoGab,-1,1)  ## [찾은번,값] 1행.
            # 현재 시접합의 이하 최대인 가지 - 다음에서 그 전1 을 읽음.
            # # 자료고 태초시 껍데기 반환. "0×2 DataFrame" 반환.

            if nrow(df_hhBumoGaji)==0  ## 특수갈래 - 자료고 태초시

                hhDocBun=1

            elseif nrow(df_hhBumoGaji)>=1  ## 일반갈래

                hhDocBun=df_hhBumoGaji[1,"CEHENGBUN"]-1

                if hhDocBun<1

                    hhDocBun=1  ## 0 보정
                end
            end

            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"JJONG_GIULGABGIL_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"JIREBI_GIULGABGIL_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"UJUN_YUCRYANG_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"UJUN_SOMOYUCRYANG_32GYUN"])
            ## 전1 32평균들 4개행 된

            ###### 결. 배치.
            df_suibJubGo_1Heng_yumgiDle=DataFrame()  ## 4개 행이 되는

            insertcols!(df_suibJubGo_1Heng_yumgiDle,"YUMGI"=>yumgiDle)  ## 결. 배치. - 1개행 (2,14.141414)
            insertcols!(df_suibJubGo_1Heng_yumgiDle,"J1_32GYUN"=>j1_32GyunDle)  ## 결. 배치. - 1개행 14.1414

            ###### 이격도인 왔갔 산출 붙이기, 배치
            watgatDle=Vector()

            for ffc in 1:4

                rra=abs(df_suibJubGo_1Heng_yumgiDle[ffc,"YUMGI"][2]/df_suibJubGo_1Heng_yumgiDle[ffc,"J1_32GYUN"])
                # ## 현재 대상의 염기/현재 대상의 1전 염기의 32개 평균. 절대.
                rrb=abs(1-rra)  ## 결. 1(100%)에서 얼마나 떨어져 있는지.
                push!(watgatDle,rrb)
            end
            ## 왔갔들 4개행 된
            insertcols!(df_suibJubGo_1Heng_yumgiDle,"WATGAT"=>watgatDle)  ## 결. 배치.

            ###### 결결. 염기서열 정렬 - 왔갔 오름차순
            sort!(df_suibJubGo_1Heng_yumgiDle,"WATGAT")
            ## df_suibJubGo_1Heng_yumgiDle 에는 3개 컬럼 [염기,'현재 대상 1전' 32평균,왔갔] 있음.

            ###### 종. DNA 확정 - 염기서열 대로
            dna=Vector()

            for ffc in 1:4

                rra=df_suibJubGo_1Heng_yumgiDle[ffc,"YUMGI"]
                push!(dna,rra)  ## dna 에 순서대로 붙이기
            end
            ## dna==[(2,),(4,),(1,),(3,)]

            ###### 종. 형 추가 - DNA 에 붙이기니까
            push!(dna,df_suibJubGo[ffb,"JUBHYUNG"])  ## dna==[(2,),(4,),(1,),(3,),110]

            ###### 종종. 유전자 확정 - 붙이기
            dnaDle[ffb]=copy(dna)
        end

        insertcols!(df_suibJubGo,"DNADLE"=>dnaDle)  ## 1개행==[(2,),(4,),(1,),(3,),110]
        ## df_suibJubGo 행수는 대체로 2임. 가끔 1.

        #################### 일반 가지산 - 바로 앞의 접합 가지산과 쌍둥이임.
        dnaDle=fill([],nrow_df_suibGajiGo)

        # @threads for ffb in 1:nrow_df_suibGajiGo  ## 가지들 수(100+32개 정도) 만큼 회전함
        for ffb in 1:nrow_df_suibGajiGo
            
            # df_suibGajiGo 에는 행이 하루치(약 100개)+32개 가 있다.
            yumgiDle=Vector()
            j1_32GyunDle=Vector()

            ###### 염기들 순서대로 붙이기
            push!(yumgiDle,[1,df_suibGajiGo[ffb,"JJONG_GIULGABGIL"]])
            push!(yumgiDle,[2,df_suibGajiGo[ffb,"JIREBI_GIULGABGIL"]])
            push!(yumgiDle,[3,df_suibGajiGo[ffb,"UJUN_YUCRYANG"]])
            push!(yumgiDle,[4,df_suibGajiGo[ffb,"UJUN_SOMOYUCRYANG"]])
            ## 염기들 4개행 된 - 1개행 (2,14.141414)

            ###### 전1 32평균 순서대로 붙이기 - 현 대상의 전1 32평균이 배치됨.
            if ffb==1  ## 특수갈래 - 이래서 1행 dna 는 첫행재 해야함. 마침강에서 선택 배제됨.

                hhDocBun=1

            elseif ffb>=2  ## 일반갈래

                hhDocBun=ffb-1  ## 현 대상의 1전을 읽어 배치함.
            end

            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"JJONG_GIULGABGIL_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"JIREBI_GIULGABGIL_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"UJUN_YUCRYANG_32GYUN"])
            push!(j1_32GyunDle,df_suibGajiGo[hhDocBun,"UJUN_SOMOYUCRYANG_32GYUN"])
            ## 전1 32평균들 4개행 된

            ###### 결. 배치.
            df_suibGajiGo_1Heng_yumgiDle=DataFrame()  ## 4개 행이 되는

            insertcols!(df_suibGajiGo_1Heng_yumgiDle,"YUMGI"=>yumgiDle)  ## 결. 배치. - 1개행 (2,14.141414)
            insertcols!(df_suibGajiGo_1Heng_yumgiDle,"J1_32GYUN"=>j1_32GyunDle)  ## 결. 배치. - 1개행 14.1414

            ###### 이격도인 왔갔 산출 붙이기, 배치
            watgatDle=Vector()

            for ffc in 1:4

                rra=abs(df_suibGajiGo_1Heng_yumgiDle[ffc,"YUMGI"][2]/df_suibGajiGo_1Heng_yumgiDle[ffc,"J1_32GYUN"])
                # ## 현재 대상의 염기/현재 대상의 1전 염기의 32개 평균. 절대.
                rrb=abs(1-rra)  ## 결. 1(100%)에서 얼마나 떨어져 있는지.
                push!(watgatDle,rrb)
            end
            ## 왔갔들 4개행 된
            insertcols!(df_suibGajiGo_1Heng_yumgiDle,"WATGAT"=>watgatDle)  ## 결. 배치.

            ###### 결결. 염기서열 정렬 - 왔갔 오름차순
            sort!(df_suibGajiGo_1Heng_yumgiDle,"WATGAT")
            ## df_suibGajiGo_1Heng_yumgiDle 에는 3개 컬럼 [염기,'현재 대상 1전' 32평균,왔갔] 있음.

            ###### 종. DNA 확정 - 염기서열 대로
            dna=Vector()

            for ffc in 1:4

                rra=df_suibGajiGo_1Heng_yumgiDle[ffc,"YUMGI"]
                push!(dna,rra)  ## dna 에 순서대로 붙이기
            end
            ## dna==[(2,),(4,),(1,),(3,)]

            ###### 종종. 유전자 확정 - 붙이기
            dnaDle[ffb]=copy(dna)
        end

        insertcols!(df_suibGajiGo,"DNADLE"=>dnaDle)  ## 1개행==[(2,),(4,),(1,),(3,)]
        ## df_suibGajiGo 에는 행이 하루치(약 100개)+32개 가 있다.

        ## 이제 대체로 행수가 2인 df_suibJubGo 와 대체로 행수가 약 100+32개인 df_suibGajiGo 에는
        # 유전자 컬럼이 존재한다. 또한 시원아이디 컬럼이 존재한다. 시원아이디 컬럼에 따라
        # 프레임일의 1일에 해당하는 기간의 유전자만 취해서 '하루의 온전한 유전자'를 완성해야 한다.

        ######################### 종. 마침강 - 시유전자, 막유전자, 중유전자 배치
        if nrow_df_suibJubGo==1  ## 특수갈래 - 하루가 시접합으로 뒤덮였을시
            #################### 시유전자 배치
            ujunjaCC[1]=[df_suibJubGo[1,"DNADLE"]]  ## 결. 배치.

            #################### 막유전자 배치 - 무일.

            #################### 중유전자 배치 - 무일.

            ## 날이 (시접합) 일시. ujunjaCC==[[유,유,유,유,유],[],[]].

        elseif nrow_df_suibJubGo==2  ## 일반갈래 - 하루에 시접합, 막접합이 존재할시.
            # 이 함축 맨 앞쪽에 ujunjaCC=fill([],3) 있음.

            #################### 시유전자 배치
            ujunjaCC[1]=[df_suibJubGo[1,"DNADLE"]]  ## 결. 배치.

            #################### 막유전자 배치
            ujunjaCC[3]=[df_suibJubGo[2,"DNADLE"]]  ## 결. 배치.

            #################### 중유전자 배치
            # - 100+32개 중 앞쪽 32개 제외되고, 한 날에 해당 하는 100개 중에서도
            # 시접합 초과부터 막접합 미만 까지 만 선택되는.
            if df_suibGajiGo_heureum==1
                # ## df_suibGajiGo_heureum==1 일시 아래 해당 가지가 반드시 1개이상 존재한다는 뜻임.

                df_hengBunChatgiVV=df_hengBunChatgi(df_suibGajiGo,"SI_WON_ID",">",df_suibJubGo[1,"SI_WON_ID"],1,1)
                hhCeJacHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

                df_hengBunChatgiVV=df_hengBunChatgi(df_suibGajiGo,"SI_WON_ID","<",df_suibJubGo[2,"SI_WON_ID"],-1,1)
                hhCeMacHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

                ujunjaCC[2]=copy(df_suibGajiGo[hhCeJacHengBun:hhCeMacHengBun,"DNADLE"])  ## 결. 배치.
            end
            # df_suibGajiGo_heureum==0 일시는 ujunjaCC[2]=Any[] 가 됨. []와 같음.
            # length([])==0 임.

            ## 날이 (시접합,막접합) 또는 (시접합,일반가지,막접합) 일시.
            # ujunjaCC==[[유,유,유,유,유],[],[유,유,유,유,유]] 또는
            # [[유,유,유,유,유],[[유],[유],[유],...],[유,유,유,유,유]]
            # 2.
            # ujunjaCC=[[[(2,),(4,),(1,),(3,),110]],[],[[(2,),(4,),(1,),(3,),110]]] 이런식.
            # ujunjaCC[1][1]==dna 1개==[(2,),(4,),(1,),(3,),110]
        end

        push!(ujunjaDle,copy(ujunjaCC))  ## 종. 프레임 날에 넣을 변수에 붙이기.
        # ujunjaDle 은 프레임 날의 행수만큼 행이 배치됨.
    end

    insertcols!(dfNal,"NE_UJUNJA"=>ujunjaDle)
    ## 프레임 날 로자료고시 - 막행 1행 유전자가 특수갈래 결과이기 때문에 막행재 해야함.

    df_abDui_print(dfNal)
    println("slNal_ne_ujunja(ib_soDongChi) 끝")
end




#################### 쏠비 참평닻: 해당일이 5일이면 4일 시작 지점에 닻을 놓고 참평닻을 구해서 5일 구간만 취해 씀.
# 그렇게 6일이면 5일 시작 지점에 닻을 놓기를 반복함.
function slNal_ssolBi()  ## 쏠비와 쏠비 참평닻 날에 맞춰 끊어서 dfNal 에 삽.
    println("function slNal_ssolBi() 시작")

    #################### 쏠비 앞일
    hhSsolBi=nothing

    ssolBiDle=fill([],nrow_dfNal)

    ffa=1
    hhNalMacSiWonId=dfNal[ffa+1,"SI_WON_ID"]
    df_hengBunChatgiVV=df_hengBunChatgi(df,"WON_ID","<",hhNalMacSiWonId,-1,1)
    hhDfSsolBi_macHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]
    hhSsolBi=copy(df[1:hhDfSsolBi_macHengBun,"GI_SSOLBI"])

    ssolBiDle[ffa]=hhSsolBi  ## 1행 진 채우기

    ########################## 본격일
    for ffa in 2:nrow_dfNal

        #################### 쏠비 날에 맞춰 끊기
        hhNalSiWonId=dfNal[ffa,"SI_WON_ID"]  ## 프레임일로부터 - 이상 읽을
        hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"]  ## 프레임일로부터 - 미만 읽을

        df_hengBunChatgiVV=df_hengBunChatgi(df,"WON_ID",">=",hhNalSiWonId,1,1)
        hhDfSsolBi_jacHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_hengBunChatgiVV=df_hengBunChatgi(df,"WON_ID","<=",hhNalMacSiWonId,-1,1)
        hhDfSsolBi_macHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        hhSsolBi=copy(df[hhDfSsolBi_jacHengBun:hhDfSsolBi_macHengBun,"GI_SSOLBI"])
        # ## 결. 쏠비 배열.

        ssolBiDle[ffa]=hhSsolBi  ## 결결. 붙이기.
    end

    insertcols!(dfNal,"GI_SSOLBI"=>ssolBiDle)

    println("function slNal_ssolBi() 끝")
end




function slNal_oi_ujunja(choWaJje)
    # ## 초와번째 - 7로함. 그러면 1+7째까지 구하는 것임. 초(1)은 언제나 구하는 것임.
    println("slNal_oi_ujunja(choWaJje) 시작")

    dfJub_c1=copy(dfJub[:,["SI_WON_ID","GAGAM_GAJI"]])
    dfGaji_c1=copy(dfGaji[:,["SI_WON_ID","GAGAM_GAJI"]])

    oi_ujunjaDle=Any[0 for i in 1:nrow_dfNal]

    ##############
    hh_ce_df_si_won_id_bun=1
    hh_ce_df_mac_won_id_bun=nrow(df)

    hh_ce_df_si_won_id_bun_2=1
    hh_ce_df_mac_won_id_bun_2=nrow(df)

    ##############
    # @threads for ffa in 1:nrow_dfNal
    for ffa in 1:nrow_dfNal
        # ## 1. 기존: 일반 갈래 - 특수 갈래 두는 이유: ffa+1 을 읽는 곳이 있음.
        # 어차피 이 대양 로고시 1일치 막행재 해야함.
        # # 2. 이제는 hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"] 도입함.

        ###################### 외면 유전자 하나
        #################### 자료고 수입하기
        hhNalSiWonId=dfNal[ffa,"SI_WON_ID"]  ## 프레임일로부터 - 이상 읽을
        # hhNalMacSiWonId=dfNal[ffa+1,"SI_WON_ID"]  ## 프레임일로부터 - 미만 읽을
        hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"]

        #################### 접합 가지산
        df_hengBunChatgiVV=df_hengBunChatgi(dfJub_c1,"SI_WON_ID",">=",hhNalSiWonId,1,1)
        dfJub_c1_jacDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_hengBunChatgiVV=df_hengBunChatgi(dfJub_c1,"SI_WON_ID","<=",hhNalMacSiWonId,-1,1)
        dfJub_c1_macDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_suibJubGo=copy(dfJub_c1[dfJub_c1_jacDocHengBun:dfJub_c1_macDocHengBun,:])
        # ## 결. 함축내 프레임 df_suibJubGo 최초 생성. # 언제나 1행 또는 2행임.
        # # 자료고 태초시 찾아짐.

        #################### 일반 가지산
        df_hengBunChatgiVV=df_hengBunChatgi(dfGaji_c1,"SI_WON_ID",">=",hhNalSiWonId,1,1)
        dfGaji_c1_jacDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_hengBunChatgiVV=df_hengBunChatgi(dfGaji_c1,"SI_WON_ID","<=",hhNalMacSiWonId,-1,1)
        dfGaji_c1_macDocHengBun=df_hengBunChatgiVV[1,"CEHENGBUN"]

        df_suibGajiGo_uMoo=nothing  ## 유무 변수

        if dfGaji_c1_jacDocHengBun>=1 && dfGaji_c1_jacDocHengBun<=dfGaji_c1_macDocHengBun

            df_suibGajiGo_uMoo=1
            df_suibGajiGo=copy(dfGaji_c1[dfGaji_c1_jacDocHengBun:dfGaji_c1_macDocHengBun,:])

        else

            df_suibGajiGo_uMoo=0
            df_suibGajiGo=nothing
        end
        # ## 결. 함축내 프레임 df_suibGajiGo 최초 생성. # 언제나 1행 또는 2행임.
        # # 자료고 태초시 찾아짐.

        #################### 접합가지 일반가지 합하기
        df_gajiDle=DataFrame()  ## 최초 생성

        append!(df_gajiDle,copy(df_suibJubGo[1:1,:]))  ## 1행만 합하기

        if df_suibGajiGo_uMoo==1

            append!(df_gajiDle,copy(df_suibGajiGo))  ## 유일 시만 모든행 합하기
        end

        if nrow(df_suibJubGo)==2

            append!(df_gajiDle,copy(df_suibJubGo[2:2,:]))  ## 2행만 합하기
        end
        ## 이로써 접합고가 1행이든,2행이든 가지고가 유든 무든 모든 경우 합하기가 완료됐음.
        # # df_gajiDle 컬럼: 시원아이디,가감가지

        #################### 접합가지 일반가지 합한 이후
        #################### 가감가지들 가감봉들로, dfGagamBongDle 만들기 - 1일의 총 봉 모음으로.
        gagamBongDle=gagamGajiDleRo_gagamBongDle(df_gajiDle[:,"GAGAM_GAJI"])
        # ## [+3,-1,+2,+1,-2,+1,+4,+1,+2,-2,+1,-1,...]
        gagamBongDleAbs=broadcast(abs,gagamBongDle)
        dfGagamBongDle=DataFrame("GAGAMBONG"=>gagamBongDle,"GAGAMBONG_ABS"=>gagamBongDleAbs)  ## 기준 프레임 최초 생성
        # # 행수가 5000~10000 행인.

        ###### 위치(안내) 마련
        anne=[i for i in 1:nrow(dfGagamBongDle)]
        insertcols!(dfGagamBongDle,1,"WC"=>anne)
        ## dfGagamBongDle 컬럼: WC 위치(안내),GAGAMBONG 봉(가감봉들),GAGAMBONG_ABS

        #################### 본격. 정렬 후 번째까지 자르기. 그 후 또 정렬.
        congBongSu=nrow(dfGagamBongDle)  ## 결결. 총 봉수 기록.

        sort!(dfGagamBongDle,"GAGAMBONG_ABS",rev=true)
        dfGagamBongDle=copy(dfGagamBongDle[1:1+choWaJje,:])  ## 결. 1+초화번째 까지 자르기. 대게 1+7=8행까지.
        sort!(dfGagamBongDle,"WC")  ## 다시 위치(안내)로 정정렬
        select!(dfGagamBongDle,Not("GAGAMBONG_ABS"))
        ## dfGagamBongDle 컬럼들: WC(안내),GAGAMBONG(가감봉)

        #
        ###################### 외면 유전자 둘
        # 외면 유전자[3]==df==컬럼: 작번,막번,음양다수봉갯수(다수개수),가감봉총합치(ggcc)
        namesVV=["JACBUN","MACBUN","DASUGESU","GGCC"]
        df_ouDul=binDf_sung(namesVV)  ## 프레임 외유전자 셋 - 매날 최초 생성.

        hhGagamBongDleBB=copy(dfNal[ffa,"GAGAM_BONG"])
        hhSsolBiDleBB=copy(dfNal[ffa,"GI_SSOLBI"])

        wwa=1

        while true

            #################### 배열의 시작행번,막행번 산출해 추린 배열 만들기
            hhSsolBiGab=hhSsolBiDleBB[wwa]  ## 와번 읽기
            hhSsolBiGab=abs(hhSsolBiGab)

            hhDocBunDuSu=hhSsolBiGab*CHg01_giGanCha_injungGesooBan  ## *4는 손잡이 - 4배수 읽음
            hhDocBunDuSu=Int(round(hhDocBunDuSu))

            hhDocJacBBhengBun=wwa  ## 결.
            hhDocMacBBhengBun=wwa+hhDocBunDuSu-1  ## 결.

            if hhDocMacBBhengBun>length(hhGagamBongDleBB)

                hhDocMacBBhengBun=length(hhGagamBongDleBB) ## 막 넘지 않게 보정
            end

            hhChoorinGagamBongDleBB=copy(hhGagamBongDleBB[hhDocJacBBhengBun:hhDocMacBBhengBun])
            # ## 결결. 산출의 대상이 되는 와일 내 추린 배열이 마련됨.

            #################### 추린 배열 만든이후 본격
            dasuGesoo=bbJung_eumYangDasuBong_gesoo(hhChoorinGagamBongDleBB)
            # ## 종. 다수개수.

            ggcc=sum(hhChoorinGagamBongDleBB)  ## 종. 가감봉총합치

            df_ouDul_1heng=[hhDocJacBBhengBun,hhDocMacBBhengBun,dasuGesoo,ggcc]
            push!(df_ouDul,df_ouDul_1heng)  ## 종결. 프레임에 이번 1행 붙이기.

            #################### wwa 와번 관리부
            hhSsolBiGab=Int(round(hhSsolBiGab))
            wwa+=hhSsolBiGab  ## 와번 증

            if wwa>length(hhGagamBongDleBB)

                break
            end
        end

        #
        ###################### 외면 유전자 셋
        hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"]
        woncheonDf_won_idRo_docVV=woncheonDf_won_idRo_doc(df,hh_ce_df_si_won_id_bun,hh_ce_df_mac_won_id_bun,
        hhNalSiWonId,hhNalMacSiWonId,["WON_ID","GI"])  ## 추린 df

        hhChoorinDf=copy(woncheonDf_won_idRo_docVV[1])
        hh_ce_df_si_won_id_bun=woncheonDf_won_idRo_docVV[2]
        hh_ce_df_mac_won_id_bun=woncheonDf_won_idRo_docVV[3]

        hhOuSet_df=dfGiSeroSuRo_dansoonHwa(hhChoorinDf,"WON_ID","GI",CHg01_seroDansoonSun_injungGesoo)
        # ## 결. 컬럼: "JACJUM","MACJUM","GARO_GURI","SERO_GURI"

        #
        ###################### 외면 유전자 넷
        hhNalMacSiWonId=dfNal[ffa,"MACSI_WON_ID"]
        woncheonDf_won_idRo_docVV2=woncheonDf_won_idRo_doc(df,hh_ce_df_si_won_id_bun_2,hh_ce_df_mac_won_id_bun_2,
        hhNalSiWonId,hhNalMacSiWonId,["WON_ID","GI","GI_SSOLBI"])
        # ## 현 대상 날 시막으로 추린 df
   
        hhChoorinDf2=copy(woncheonDf_won_idRo_docVV2[1])
        hh_ce_df_si_won_id_bun_2=woncheonDf_won_idRo_docVV2[2]
        hh_ce_df_mac_won_id_bun_2=woncheonDf_won_idRo_docVV2[3]

        hh_giJoongGi=df_giColWaBongChiColRo_giJoongGi(hhChoorinDf2,"GI","GI_SSOLBI",CHg01_giGanCha_injungGesooBan,8)
        # ## 결. 기중기.

        hhOuNet_bb=hhChoorinDf2[:,"GI"]-hh_giJoongGi  ## 종. 기와 기중기간 차. 기중기 왔갔.

        #
        #################### 종.
        ujunja1Heng=[congBongSu,dfGagamBongDle,df_ouDul,hhOuSet_df,hhOuNet_bb]
        # ## 종. 외유전자 1행 마련

        oi_ujunjaDle[ffa]=copy(ujunja1Heng)  ## 종결. 붙이기.
    end

    insertcols!(dfNal,"OI_UJUNJA"=>oi_ujunjaDle)
    ## 프레임 날 로자료고시 - 막행 1행 유전자가 특수갈래 결과이기 때문에 막행재 해야함.

    println("slNal_oi_ujunja(choWaJje) 끝")
end




function slNal_hengJe()
    # ## 100비유: df 가 원천고 80~1000까지이니까, df 로만 구해지는 프레임 날도 80~1000까지 구해져 있다.
    # 그런데 990까지는 진짜지만 막판 1일치 10은 짜가다.
    # 막판 1일치 짜가류들인데: slNal_si_geuDle(),slNal_ne_ujunja(CHg01_soDongChi),slNal_oi_ujunja(7)
    # 자료고 태초시: 첫행재 할 필요없고, 막행재는 일상시 처럼 하루치 1행 하면 됨.
    # 이상 기존.
    println("slNal_hengJe() 시작")

    if sl_nal_idSu>=1  ## 일반 갈래- 자료고 태초시는 할일 없음

        nalGoMacIdHengBun=dfHengBun(dfNal,"NAL_ID",sl_nal_macId,1)
        # ## 바로 이 직후부터 로자료고에 필요하니 아래서 +1
        global dfNal=copy(dfNal[nalGoMacIdHengBun+1:end,:])  ## 첫행재 - 사실상 1행 자르는

    end

    println("slNal_hengJe() 끝")
end




function slNal_colSac()
    println("function slNal_colSac() 시작")

    select!(dfNal,Not("GAGAM_BONG"))
    select!(dfNal,Not("GI_SSOLBI"))

    println("function slNal_colSac() 끝")
end


