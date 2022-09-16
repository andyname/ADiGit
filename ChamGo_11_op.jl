

"""
2022년 9월 1일. 오전 11시51분. - copy 점검 완료.
"""




################ 전 일 - 최초 켰다시 할 일
function ChamGoJun(junsangi,goEreum::String,goMucGesuFF=100,goGibeFF=4)
    println("function ChamGoJun 시작")

    ##################
    if junsangi==1

        junsangiDrive="D:"

    elseif junsangi==2

        junsangiDrive="B:"

    elseif junsangi==3

        junsangiDrive="D:"
    end

    ##################
    readdirVV=readdir(junsangiDrive)

    if goEreum ∉ readdirVV

        hhMkPathString=junsangiDrive*"\\"*goEreum
        mkpath(hhMkPathString)  ## 결. 만들기  
    end

    global ChamGoIbguCong=junsangiDrive*"\\"*goEreum

    ##################
    global goMucGesu=goMucGesuFF  ## 묶음 개수- 막장 폴더 1개에 배치되는 퍄일의 수
    global goGibe=goGibeFF  ## 깊이- 
    # t3(테이블에서 3계단 더 있는데가 마지막 폴더 있는곳. 퍄일은 4층에 있는 것이 됨.)

    println("function ChamGoJun 막")
end




################ 테이블 폴더가 없을시 만들기 - 테이블 폴더 경로 반환
function tableFolderSung(goTableEreum::String,goGibe=2)
    # ## 입력: 깊이- t2(테이블에서 2계단 더 있는데가 마지막 폴더 있는곳)
    println("function tableFolderSung 시작")

    readdirVV=readdir(ChamGoIbguCong)
    readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

    if goTableEreum ∉ readdirVV  ## 없을 시만 만들기

        mkpathString=ChamGoIbguCong*"\\"*goTableEreum  
        # ## "C:\\ChamGo\\Table" 총이름

        for ffa in 1:goGibe  ## 깊이 만큼 마련

            mkpathString*="\\AoSIN"
        end

        mkpath(mkpathString)  ## 결. 만들기  
    end

    tableFolderCong=ChamGoIbguCong*"\\"*goTableEreum  ## "C:\\ChamGo\\Table" 총이름

    println("function tableFolderSung 막")
    return tableFolderCong 
end




################ 테이블 폴더 총이름 입력하면 막장 총이름 반환
function tableFolderRo_macjangFolderCong(tableFolderCong)
    println("function tableFolderRo_macjangFolderCong 시작")

    macjangFolderCong=Vector()

    hhCong=tableFolderCong
    push!(macjangFolderCong,hhCong)  ## 결. ["C:\\ChamGo\\Table"] 최초 붙이기

    for ffa in 1:goGibe

        readdirVV=readdir(hhCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        if "AoSIN" ∈ readdirVV

            hhCong*="\\AoSIN"
            push!(macjangFolderCong,hhCong)  ## 결.

        else  ## 신 폴더 없을시 읽은것중 마지막 폴더 이름 붙임

            if length(readdirVV)>=1  ## ["IDv10000v10001"] 있을 시

                hhCong*="\\"
                hhCong*=readdirVV[end]
                push!(macjangFolderCong,hhCong)  ## 결.
            end
        end
    end

    println(macjangFolderCong[end])
    println("function tableFolderRo_macjangFolderCong 막")
    return macjangFolderCong  ## 막장 폴더 총이름 - 깊이 3이면 길이 4가 됨.
    # # "C:\\ChamGo\\AoSIN\\AoSIN" # "C:\\ChamGo\\id_1_10000\\id_9900_10000"
end




################ 참고원소이름 을 풀어서 정리한 df로 - 이름 1개(1행)가 df 1개가 됨.
function ChamGoWonsoEreumRo_wonsoEreumDf(ChamGoWonsoEreum)
  
    splitVV1=split(ChamGoWonsoEreum,"\\")
    # ## ChamGoWonsoEreum="C:\\ChamGo\\ORIGO\\ID,1,1000040,EPOCHMS,2001,1002040" 
    # 이런식으로 생겼기 때문에.

    splitVV=split(splitVV1[end],"v")  ## 결. "v" 손잡이- 구별자
    
    secinSu=length(splitVV)/3
    secunSu=Int(round(secinSu))

    namesVV=["SECIN","JACGAB","MACGAB"]
    df_wonsoEreum=binDf_sung(namesVV)

    for ffa in 1:secunSu

        hhSecinBun=1+(3*(ffa-1))
        hhChoGabBun=hhSecinBun+1
        hhMacGabBun=hhSecinBun+2

        hhChoGabBunGab=parse(Int,splitVV[hhChoGabBun])  ## 정수만 됨.

        findlastVV=findlast(".cs",splitVV[hhMacGabBun])     

        if findlastVV==nothing

            hhGab=splitVV[hhMacGabBun]

        else

            splitVV2=split(splitVV[hhMacGabBun],".")
            hhGab=splitVV2[1]
        end
        
        hhMacGabBunGab=parse(Int,hhGab)
        hhBB=[splitVV[hhSecinBun],hhChoGabBunGab,hhMacGabBunGab]

        push!(df_wonsoEreum,hhBB)
        # ## 결결. 붙이기. ["문자",정수,정수] # 색인은 정수만 됨.
    end

    return df_wonsoEreum  ## ["SECIN","JACGAB","MACGAB"]
end




################ 원소이름 df(string,Int,Int) 를 참고원소이름(string)으로 만들어 반환
function wonsoEreumDfRo_ChamGoWonsoEreum(df_wonsoEreum)

    sizeVV=size(df_wonsoEreum)

    ChamGoWonsoEreum=""  ## 결. 최초 생성

    for ffa in 1:nrow(df_wonsoEreum)  ## 세로로 행 순

        for ffb in 1:sizeVV[2]  ## 가로로 컬럼 순

            hhGab=df_wonsoEreum[ffa,ffb]  ## ["ID"]

            if ffa==1 && ffb==1  ## 최초시만 구별자 "v" 없이.

                ChamGoWonsoEreum*=string(hhGab)  ## 붙이기.

            else  ## 최초 아닐시 구별자 "v" 붙여서

                ChamGoWonsoEreum*="v"
                ChamGoWonsoEreum*=string(hhGab)  ## 붙이기.
            end
        end
    end

    return ChamGoWonsoEreum  ## "IDv10000v10010vEPOCHMSv12345v12346"
end




################ 원소이름 df 입력하면 그 중 막값만 수정하는 것.
function wonsoEreumDf_macGabSujung(df_wonsoEreum,halGabDle)
    # ## 입력:수정할 값들=["ID",막값(1010)] 
   
    secinDle=halGabDle[1]
    macGabDle=halGabDle[2]

    for ffa in 1:length(secinDle)  ## 세로 행

        if df_wonsoEreum[ffa,1]==secinDle[ffa]  ## 색인이 같을시

            df_wonsoEreum[ffa,3]=macGabDle[ffa]  ## 결. 막값 수정.
        end
    end

    return df_wonsoEreum
end




################ 폴더 이름을 참고원소이름으로 수정하는 것
function folderDle_ereumJe(macjangFolderCong,secin,macGabDle)
    # ## 입력: 최초유무- 1 최초, 2 최초 아닌 
   
    for ffa in length(macjangFolderCong):-1:2
        # ## 현막장총 폴더에서 현재 이름, 바꿀 이름을 마련하고 
        # 그 후 1계단 상위 폴더로 올라가서 바꾼다. 그러니 2까지.

        hhMacjangFolderCong=macjangFolderCong[ffa]
        splitVV=split(hhMacjangFolderCong,"\\")

        if splitVV[end]=="AoSIN"  ## 폴더명이 AoSIN 으로 존재할때 갈래

            readdirVV=readdir(hhMacjangFolderCong)

            splitVV=split(readdirVV[1],".")  ## ".cs" 자르기

            sujungDesangFolderEreum=macjangFolderCong[ffa]
            sujungHalFolderEreum=macjangFolderCong[ffa-1]*"\\"*splitVV[1]

            # cd(ChamGoIbguCong)
            Base.Filesystem.rename(sujungDesangFolderEreum,sujungHalFolderEreum)  ## 종. 폴더 이름 수정.

            macjangFolderCong=
            folderCongBB_ttunBunEhu_sujung_teuc(macjangFolderCong,ffa,sujungHalFolderEreum)
            # ## 결. 막장폴더총 변수 수정된 이름으로.

        else  ## 폴더명이 AoSIN 이 아니라 기 존재시 갈래

            sujungDesangFolderEreum=splitVV[end]  ## 결결. 수정대상 폴더 이름

            ############# 수정할 폴더 이름 마련
            df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(sujungDesangFolderEreum)

            halGabDle=[secin,macGabDle]
            se_df_wonsoEreum=wonsoEreumDf_macGabSujung(df_wonsoEreum,halGabDle)  ## 결. 수정 된.

            sujungHalFolderEreum=wonsoEreumDfRo_ChamGoWonsoEreum(se_df_wonsoEreum)  
            # ## 결결. 수정할 폴더 이름.

            ############# 종. 총이름 들로 만들어 폴더명 수정
            sujungDesangFolderEreum=macjangFolderCong[ffa-1]*"\\"*sujungDesangFolderEreum
            sujungHalFolderEreum=macjangFolderCong[ffa-1]*"\\"*sujungHalFolderEreum

            # cd(ChamGoIbguCong)
            Base.Filesystem.rename(sujungDesangFolderEreum,sujungHalFolderEreum)  ## 종. 폴더 이름 수정.
        
            macjangFolderCong=
            folderCongBB_ttunBunEhu_sujung_teuc(macjangFolderCong,ffa,sujungHalFolderEreum)
            # ## 결. 막장폴더총 변수 수정된 이름으로.
        end
    end
    
    return macjangFolderCong  ## 수정된 것 반환
end




################ 신 폴더 생성 필요 유무 판단해서 필요 유시 생성하는 함축
function sinFolder_sung(macjangFolderCong)
    println("function sinFolder_sung 시작")

    ################### 필요폴더층번 산출(macjangFolderCong에서의 번)
    pilyoFolderCheungBun=Vector()

    for ffa in length(macjangFolderCong):-1:2  ## 4,3,2(=3,2,1층)

        hhMacjangFolderCong=macjangFolderCong[ffa]
        readdirVV=readdir(hhMacjangFolderCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        if length(readdirVV)>=goMucGesu

            # ## 결. 필요폴더층번(macjangFolderCong에서의 번) 붙이기. 
            # # 이 층에 신 폴더 생성 요망.

            if ffa==length(macjangFolderCong)  ## 최초 회전(맨아래층) 시는 그냥 붙음.

                push!(pilyoFolderCheungBun,ffa)   ## ".cs" 퍄일이 있는 곳은 3+1인 4층임.

            else

                if length(pilyoFolderCheungBun)>=1 && ffa==pilyoFolderCheungBun[end]-1  
                    # ## 하나 더 아래층이 차야지만 붙기 허용
                    push!(pilyoFolderCheungBun,ffa) 
                end
            end
        end
    end

    ################### 필요할 시만 본격 생성
    if length(pilyoFolderCheungBun)>=1  ## 붙었을시만 통과

        ############ 예비 일
        forSu=length(pilyoFolderCheungBun)
        hhMandleFolder=macjangFolderCong[pilyoFolderCheungBun[end]-1] 

        ############ 본격 붙이기
        for ffa in 1:forSu

            hhMandleFolder*="\\"
            hhMandleFolder*="AoSIN"  ## 붙이기
        end

        println("function sinFolder_sung / mkpath(hhMandleFolder)=$(hhMandleFolder)")
        mkpath(hhMandleFolder)  ## 종. 폴더 만들기.
    end

    println("function sinFolder_sung 막")
end




################ df 를 참고로 - insert,append
function dfRoChamGo_ne1(goTableEreum,dfGo,secinBB=["ID"])
    # ## 입력: 색인=["ID","EPOCHMS"] 이런식. 퍄일명에는 앞 두 글자가 포함 됨. "EP" 이런식.
 
    ############### 막장 폴더 총이름 마련
    tableFolderCong=tableFolderSung(goTableEreum,goGibe)  
    # ## 깊이 2 손잡이 이나 한번 정하면 그대로 써야 함.
    macjangFolderCong=tableFolderRo_macjangFolderCong(tableFolderCong)  ## 결. 막장 폴더 총이름.

    ############### 퍄일 이름 마련
    jacGabDle=Vector()
    macGabDle=Vector()

    fileEreum=nothing

    for ffa in 1:length(secinBB)

        hhSecin=secinBB[ffa]  ## "ID"

        if ffa==1

            fileEreum=hhSecin  ## "ID"

        elseif ffa>=2

            fileEreum*="v"
            fileEreum*=hhSecin  ## "vEP"
        end

        ########## 시작 값
        fileEreum*="v"
        hhGab=dfGo[1,hhSecin]
        fileEreum*=string(hhGab)  ## 시작 값 붙이기 

        push!(jacGabDle,hhGab)  ## 시작 값들 모으기
        
        ########## 막 값
        fileEreum*="v"
        hhGab=dfGo[end,hhSecin]
        fileEreum*=string(hhGab)  ## 막 값 붙이기 

        push!(macGabDle,hhGab)  ## 시작 값들 모으기
    end
 
    fileEreum*=".cs"  ## 확장자 붙이기
    ## "IDv100v200vEPOCHMSv12345v12349.cs"

    ############### 총총이름 마련 후 로고
    congCong=macjangFolderCong[end]*"\\"*fileEreum

    serialize(congCong,dfGo)
  
    #
    ############### 로고 이후 정보 정리
    ########### 폴더 이름 변경
    macjangFolderCong=folderDle_ereumJe(macjangFolderCong,secinBB,macGabDle)

    ########### 신 폴더 생성부 - 필요시만 생성함.
    sinFolder_sung(macjangFolderCong)  ## 종. AoSIN 폴더 생성.
 
    rra=[1,nrow(dfGo),0]  ## [최종 성공 유무,성공행 수,실패행 수] - 형식상 반환값.

    return rra
end 




################ df 를 참고로 - insert,append
function dfRoChamGo(goHyung,goTableEreum,dfGo,secinBB=["ID"])

    #################### 퍄일당 묶음 수 배정
    if goHyung=="WON"

        fileDangMucSu=40*6

    elseif goHyung=="GAJI"

        fileDangMucSu=40*6

    elseif goHyung=="JUB"

        fileDangMucSu=40*6

    elseif goHyung=="NAL"

        fileDangMucSu=40*6

    elseif goHyung=="DABROC"

        fileDangMucSu=1

    elseif goHyung=="MIPADO"

        fileDangMucSu=1

    elseif goHyung=="IBJANGBU"

        fileDangMucSu=40*6

    elseif goHyung=="ROC"
        
        fileDangMucSu=40*6
    end

    #################### 포문 준비
    divremVV=divrem(nrow(dfGo),fileDangMucSu)

    #################### 본격 포문 로고
    if divremVV[1] !=0

        for ffa in 1:divremVV[1]

            hhJacBun=fileDangMucSu*(ffa-1)+1
            hhMacBun=fileDangMucSu*ffa 

            dfGo_hh=copy(dfGo[hhJacBun:hhMacBun,:])
            dfRoChamGo_ne1VV=dfRoChamGo_ne1(goTableEreum,dfGo_hh,secinBB)
        end
    end

    #################### 마무리 로고
    if divremVV[2] !=0

        ffa=divremVV[1]+1

        hhJacBun=fileDangMucSu*(ffa-1)+1
        hhMacBun=nrow(dfGo)

        dfGo_hh=copy(dfGo[hhJacBun:hhMacBun,:])
        dfRoChamGo_ne1VV=dfRoChamGo_ne1(goTableEreum,dfGo_hh,secinBB)
    end

    rra=[1,nrow(dfGo),0]  ## [최종 성공 유무,성공행 수,실패행 수] - 형식상 반환값.

    return rra
end




################ [총이름,총이름 푼 df_wonsoEreum] 이 1행인, 이런 행이 최대 100행인 df 반환
function ChamGoFolderDocRo_punFolderDf(folderCongEreum)
  
    namesVV=["EREUM_MAN","CONG","DF"]
    df_folder=binDf_sung(namesVV)

    readdirVV=readdir(folderCongEreum,join=true)
    readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

    readdirVV2=readdir(folderCongEreum)
    readdirVV2=ChamGoWonsoEreum_jungRyul(readdirVV2,1)

    for ffa in 1:length(readdirVV)

        hhDf_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(readdirVV[ffa])
        hhBB=[readdirVV2[ffa],readdirVV[ffa],hhDf_wonsoEreum]

        push!(df_folder,hhBB)  
        # ## ["EREUM_MAN","CONG","DF"]
    end
    ## df_folder 는 최대 100행이 됨.

    return df_folder
end




################ 불러오기 - select 
# 깊이 독립적
function ChamGoRoDf_j1(goTableEreum,secinJwaGab,bdh1,secin,bdh2,secinUGab)
    # ## 입력: ChamGoRoDf(테이블이름만,1004,"<","ID","<=",1005) - "<","<="만 됨.

    readdirVV1=readdir(ChamGoIbguCong)

    if goTableEreum ∉ readdirVV1

        return nothing  ## 없을시 nothing 반환

    elseif goTableEreum ∈ readdirVV1

        df_ce_jwa=ChamGoRoDf_jwaChatHagang(goTableEreum,secinJwaGab,secin)
        df_ce_u=ChamGoRoDf_uChatHagang(goTableEreum,secin,secinUGab)
        
        #
        ##################### 읽을 퍄일이름 모음 - 좌끝,중간,우끝 마련
        joongganFileCongEreumMoum=Vector()  ## 중간을 모으다 보면 맨막 ffa=4 에서 
        # 좌끝,우끝도 모으는 것이니 중간퍄일총이름모음이라 함. 

        ############## 1행 일
        ffa=1
        hhBunjjeCha_1HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

        if hhBunjjeCha_1HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
            
            hhJungFolderBun=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
            
            if length(hhJungFolderBun)>=1

                for ffb in hhJungFolderBun[1]:hhJungFolderBun[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,hhFileEreumMoum)  ## 결. 중간 퍄일이름 모은.
                end
            end
        end
        
        ############## 2행 일
        ffa=2
    
        if hhBunjjeCha_1HengSi==0  ## 1층에서 좌막,우막이 같은 폴더 였을시

            hhBunjjeCha_2HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_2HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun)>=1

                    for ffb in hhJungFolderBun[1]:hhJungFolderBun[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end
        
        elseif hhBunjjeCha_1HengSi>=1

            hhBunjjeCha_2HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun2=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun2)>=1

                for ffb in hhJungFolderBun2[1]:hhJungFolderBun2[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun2=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]

            if length(hhJungFolderBun2)>=1

                for ffb in hhJungFolderBun2[1]:hhJungFolderBun2[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 3행 일
        ffa=3

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhBunjjeCha_3HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_3HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun3)>=1
                    
                    for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            hhBunjjeCha_3HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 4행 일
        ffa=4

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 && hhBunjjeCha_3HengSi==0  
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhBunjjeCha_4HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_4HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun3)>=1
                    
                    for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            hhBunjjeCha_4HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]
           
            if length(hhJungFolderBun3)>=1
             
                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)
                 
                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 5행 일 - 막장굴
        ffa=5

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 && hhBunjjeCha_3HengSi==0 && hhBunjjeCha_4HengSi==0 
            # ## 1층,2층,3층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[df_ce_jwa[ffa,"BUNJJE"]:df_ce_u[ffa,"BUNJJE"]]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 끝.

        else  ## 그외 모든 갈래

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[df_ce_jwa[ffa,"BUNJJE"]:length(readdirVV)]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 좌끝.

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[1:df_ce_u[ffa,"BUNJJE"]]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 우끝.
        end

        ############# 하나씩만,정정렬
        joongganFileCongEreumMoum=wonsoHanaSsicMan(joongganFileCongEreumMoum)
        sort!(joongganFileCongEreumMoum)
        ## 이로서 읽어야할 모든 퍄일총이름을 모았다. joongganFileCongEreumMoum 여기에.

        #
        ##################### 읽을 퍄일이름 모음 이후 본격
        df_punHana=fileCongEreumDleRo_dfHana(joongganFileCongEreumMoum)  ## 결. df 하나로 합친
        sort!(df_punHana,secin)

        ################# 끊어 읽을 시작번,막번 찾기
        ############# 시작번
        ceJacBun=1

        for ffa in 1:nrow(df_punHana)

            if bdh1=="<"

                if secinJwaGab<df_punHana[ffa,secin]

                    ceJacBun=ffa
                    break
                end

            elseif bdh1=="<="

                if secinJwaGab<=df_punHana[ffa,secin]

                    ceJacBun=ffa
                    break
                end
            end
        end

        ############# 막번
        ceMacBun=nrow(df_punHana)

        for ffa in nrow(df_punHana):-1:1

            if bdh2=="<"

                if df_punHana[ffa,secin]<secinUGab

                    ceMacBun=ffa
                    break
                end

            elseif bdh2=="<="

                if df_punHana[ffa,secin]<=secinUGab

                    ceMacBun=ffa
                    break
                end
            end
        end

        ################# 종. 끊어서 반환
        df_rra=copy(df_punHana[ceJacBun:ceMacBun,:])  ## 종. 끊기.
    
        return df_rra
    end
end




################ 불러오기 - select 
# 깊이 독립적
# 2022년 9월 5일 오후 5시41분- 수정 시작한.
function ChamGoRoDf(goTableEreum,secinJwaGab,bdh1,secin,bdh2,secinUGab)
    # ## 입력: ChamGoRoDf(테이블이름만,1004,"<","ID","<=",1005) - "<","<="만 됨.

    readdirVV1=readdir(ChamGoIbguCong)

    if goTableEreum ∉ readdirVV1

        return nothing  ## 없을시 nothing 반환

    elseif goTableEreum ∈ readdirVV1

        df_ce_jwa=ChamGoRoDf_jwaChatHagang(goTableEreum,secinJwaGab,secin)
        df_ce_u=ChamGoRoDf_uChatHagang(goTableEreum,secin,secinUGab)
        
        #
        ##################### 읽을 퍄일이름 모음 - 좌끝,중간,우끝 마련
        joongganFileCongEreumMoum=Vector()  ## 중간을 모으다 보면 맨막 ffa=4 에서 
        # 좌끝,우끝도 모으는 것이니 중간퍄일총이름모음이라 함. 

        ############## 1행 일
        ffa=1
        hhBunjjeCha_1HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

        if hhBunjjeCha_1HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
            
            hhJungFolderBun=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
            
            if length(hhJungFolderBun)>=1

                for ffb in hhJungFolderBun[1]:hhJungFolderBun[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,hhFileEreumMoum)  ## 결. 중간 퍄일이름 모은.
                end
            end
        end
        
        ############## 2행 일
        ffa=2
    
        if hhBunjjeCha_1HengSi==0  ## 1층에서 좌막,우막이 같은 폴더 였을시

            hhBunjjeCha_2HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_2HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun)>=1

                    for ffb in hhJungFolderBun[1]:hhJungFolderBun[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end
        
        elseif hhBunjjeCha_1HengSi>=1

            hhBunjjeCha_2HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun2=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun2)>=1

                for ffb in hhJungFolderBun2[1]:hhJungFolderBun2[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun2=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]

            if length(hhJungFolderBun2)>=1

                for ffb in hhJungFolderBun2[1]:hhJungFolderBun2[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 3행 일
        ffa=3

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhBunjjeCha_3HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_3HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun3)>=1
                    
                    for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            hhBunjjeCha_3HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 4행 일
        ffa=4

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 && hhBunjjeCha_3HengSi==0  
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhBunjjeCha_4HengSi=df_ce_u[ffa,"BUNJJE"]-df_ce_jwa[ffa,"BUNJJE"]

            if hhBunjjeCha_4HengSi>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:df_ce_u[ffa,"BUNJJE"]-1]
                
                if length(hhJungFolderBun3)>=1
                    
                    for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                        hhFileEreumMoum=
                        ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                        append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            hhBunjjeCha_4HengSi=-1004.1004  ## 껍데기 대입

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in df_ce_jwa[ffa,"BUNJJE"]+1:length(readdirVV)]

            if length(hhJungFolderBun3)>=1

                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_jwa[ffa,"HHCONG"],ffb)

                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhJungFolderBun3=[i for i in 1:df_ce_u[ffa,"BUNJJE"]-1]
           
            if length(hhJungFolderBun3)>=1
             
                for ffb in hhJungFolderBun3[1]:hhJungFolderBun3[end]

                    hhFileEreumMoum=
                    ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(ffa,df_ce_u[ffa,"HHCONG"],ffb)
                 
                    append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 5행 일 - 막장굴
        ffa=5

        if hhBunjjeCha_1HengSi==0 && hhBunjjeCha_2HengSi==0 && hhBunjjeCha_3HengSi==0 && hhBunjjeCha_4HengSi==0 
            # ## 1층,2층,3층에서 좌막,우막이 같은 폴더 였을시 갈래

            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[df_ce_jwa[ffa,"BUNJJE"]:df_ce_u[ffa,"BUNJJE"]]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 끝.

        else  ## 그외 모든 갈래

            ############# 좌막
            hhCong=df_ce_jwa[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[df_ce_jwa[ffa,"BUNJJE"]:length(readdirVV)]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 좌끝.

            ############# 우막
            hhCong=df_ce_u[ffa-1,"HHCONG"]
            readdirVV=readdir(hhCong,join=true)
            readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
            readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

            hhFileEreumMoum=readdirVV[1:df_ce_u[ffa,"BUNJJE"]]

            append!(joongganFileCongEreumMoum,copy(hhFileEreumMoum))  ## 종. 퍄일 모음 우끝.
        end

        ############# 하나씩만,정정렬
        joongganFileCongEreumMoum=wonsoHanaSsicMan(joongganFileCongEreumMoum)
        sort!(joongganFileCongEreumMoum)
        ## 이로서 읽어야할 모든 퍄일총이름을 모았다. joongganFileCongEreumMoum 여기에.

        #
        ##################### 읽을 퍄일이름 모음 이후 본격
        df_punHana=fileCongEreumDleRo_dfHana(joongganFileCongEreumMoum)  ## 결. df 하나로 합친
        sort!(df_punHana,secin)

        ################# 끊어 읽을 시작번,막번 찾기
        ############# 시작번
        ceJacBun=1

        for ffa in 1:nrow(df_punHana)

            if bdh1=="<"

                if secinJwaGab<df_punHana[ffa,secin]

                    ceJacBun=ffa
                    break
                end

            elseif bdh1=="<="

                if secinJwaGab<=df_punHana[ffa,secin]

                    ceJacBun=ffa
                    break
                end
            end
        end

        ############# 막번
        ceMacBun=nrow(df_punHana)

        for ffa in nrow(df_punHana):-1:1

            if bdh2=="<"

                if df_punHana[ffa,secin]<secinUGab

                    ceMacBun=ffa
                    break
                end

            elseif bdh2=="<="

                if df_punHana[ffa,secin]<=secinUGab

                    ceMacBun=ffa
                    break
                end
            end
        end

        ################# 종. 끊어서 반환
        df_rra=copy(df_punHana[ceJacBun:ceMacBun,:])  ## 종. 끊기.
    
        return df_rra
    end
end




################ 불러오기 중 좁히기 전용
function ChamGoRoDf_uChatHagang(goTableEreum,secin,secinUGab)

    nameVV=["HHCONG","BUNJJE","EREUM_MAN"]
    df_chatgi=binDf_sung(nameVV)  ## 결. df 최초 마련.

    hhFolderCongEreum=ChamGoIbguCong*"\\"*goTableEreum  ## "C:\\ChamGo\\Table" 총이름

    gibe_cca=0

    while true

        hhDf_folder=ChamGoFolderDocRo_punFolderDf(hhFolderCongEreum)  ## 최대 100행인

        ############### 보정
        if hhDf_folder[1,"EREUM_MAN"]=="AoSIN"

            hhDf_folder=copy(hhDf_folder[setdiff(1:end,1),:])
        end

        ############### 우측 막값 찾기
        ceGabWc=nothing
        daCe=0  ## 다 찾은 0

        for ffa in nrow(hhDf_folder):-1:1

            hhDf_wonsoEreum=hhDf_folder[ffa,"DF"]  ## ["SECIN","JACGAB","MACGAB"]

            for ffb in 1:nrow(hhDf_wonsoEreum)

                hhSecin=hhDf_wonsoEreum[ffb,"SECIN"]  ## 단순히 색인이 같을 시를 위한

                if hhSecin==secin  ## 단순히 색인이 같을 시

                    ########## 결. 찾아서 위치 기록
                    if secinUGab<=hhDf_wonsoEreum[ffb,"MACGAB"]

                        ceGabWc=ffa  ## 결. 찾은 막값 위치 ffa
                      
                    elseif hhDf_wonsoEreum[ffb,"MACGAB"]<secinUGab

                        if ffa==nrow(hhDf_folder)  

                            ceGabWc=ffa  ## secinUGab 먼산 일시 처리
                        end

                        daCe=1
                        break
                    end
                end
            end

            if daCe==1
                break
            end
        end

        ############### 찾은 이후 정보 정리
        hh1Heng=[hhDf_folder[ceGabWc,"CONG"],ceGabWc,hhDf_folder[ceGabWc,"EREUM_MAN"]]  
        # ## 결. df 에 붙일 1행 - 최초시 "C:\\ChamGo\\Table\\IDv100v110" - 1단계 
        # # global goGibe=3 이면 4단계까지 붙고, 4단계에 .cs 퍄일명이 있다.
        push!(df_chatgi,hh1Heng)  ## 결. 붙이기.

        ########### 브레이크 부
        gibe_cca+=1

        if gibe_cca>=goGibe+1

            break
        end

        ########### 회전하는 hhFolderCongEreum 갱신
        hhFolderCongEreum*="\\"
        hhFolderCongEreum*=hhDf_folder[ceGabWc,"EREUM_MAN"]
    end

    return df_chatgi  ## ["HHCONG","BUNJJE","EREUM_MAN"] 
    # # df_chatgi 막행 이하를 수입해야 함.
end




################ 불러오기 중 좁히기 전용
function ChamGoRoDf_jwaChatHagang(goTableEreum,secinJwaGab,secin)

    nameVV=["HHCONG","BUNJJE","EREUM_MAN"]
    df_chatgi=binDf_sung(nameVV)  ## 결. df 최초 마련.

    hhFolderCongEreum=ChamGoIbguCong*"\\"*goTableEreum  ## "C:\\ChamGo\\Table" 총이름

    gibe_cca=0

    while true

        hhDf_folder=ChamGoFolderDocRo_punFolderDf(hhFolderCongEreum)  ## 최대 100행인

        ############### 보정
        if hhDf_folder[1,"EREUM_MAN"]=="AoSIN"

            hhDf_folder=copy(hhDf_folder[setdiff(1:end,1),:])
        end

        ############### 우측 막값 찾기
        ceGabWc=nothing
        daCe=0  ## 다 찾은 0

        for ffa in 1:nrow(hhDf_folder)

            hhDf_wonsoEreum=hhDf_folder[ffa,"DF"]  ## ["SECIN","JACGAB","MACGAB"]

            for ffb in 1:nrow(hhDf_wonsoEreum)

                hhSecin=hhDf_wonsoEreum[ffb,"SECIN"]  ## 단순히 색인이 같을 시를 위한

                if hhSecin==secin  ## 단순히 색인이 같을 시

                    ########## 결. 찾아서 위치 기록
                    if hhDf_wonsoEreum[ffb,"JACGAB"]<=secinJwaGab

                        ceGabWc=ffa  ## 결. 찾은 막값 위치 ffa
                    
                    elseif secinJwaGab<hhDf_wonsoEreum[ffb,"JACGAB"]
                     
                        if ffa==1 

                            ceGabWc=ffa  ## secinJwaGab 먼산 일시 처리
                        end
                     
                        daCe=1
                        break
                    end
                end
            end
       
            if daCe==1

                break
            end
        end

        ############### 찾은 이후 정보 정리
        hh1Heng=[hhDf_folder[ceGabWc,"CONG"],ceGabWc,hhDf_folder[ceGabWc,"EREUM_MAN"]]  
        # ## 결. df 에 붙일 1행
        push!(df_chatgi,hh1Heng)  ## 결. 붙이기.

        ########### 브레이크 부
        gibe_cca+=1

        if gibe_cca>=goGibe+1

            break
        end

        ########### 회전하는 hhFolderCongEreum 갱신
        hhFolderCongEreum*="\\"
        hhFolderCongEreum*=hhDf_folder[ceGabWc,"EREUM_MAN"]
    end

    return df_chatgi  ## ["HHCONG","BUNJJE","EREUM_MAN"] 
    # # df_chatgi 막행 이상을 수입해야 함.
end




################ 폴더번이 본폴더가 되고 그 폴더 이하 막장의 jls 퍄일 이름을 읽어 모으는 것
# - global goGibe=3 층만 됨. 참고전에서 층을 바꾸면 이 함축이 전부 수정돼야 함.
# 2. goGibe=4 층으로 수정함.
# 깊이 독립적
function ChamGoRoDf_congWafolderBunRo_macjangFileEreumMoum(jeCongHhDan,jeCong,bonFolderBun)
    # ## 입력: 형제폴더현재단- 1이면 1단 / 형제폴더의 총이름- ChamGoRoDf_jwaChatHagang 의 행 HHCONG 
    # / 형제폴더가 있는 곳을 정정렬시 본 폴더의 번째
    # # jeCongHhDan 막장부터 1층으로 올라오며 짰다. 그래서 1층 쪽 변수들이 퍄일명에 3이 붙음.

    fileEreumMoum=Vector()

    if jeCongHhDan==1

        ############# 1층 일
        sang_congEreum4=congEreumRo_sangSeung(jeCong,1)  ## 테이블 층
        readdirVV4=readdir(sang_congEreum4,join=true)  ## 2층 220개
        readdirVV4=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV4,"AoSIN")
        readdirVV4=ChamGoWonsoEreum_jungRyul(readdirVV4,1)

        readdirVV_na4=readdir(readdirVV4[bonFolderBun],join=true)  ## 3층 100개
        readdirVV_na4=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na4,"AoSIN")
        readdirVV_na4=ChamGoWonsoEreum_jungRyul(readdirVV_na4,1)

        for ffc in 1:length(readdirVV_na4)

            ############# 2층 일
            hhFolder4=readdirVV_na4[ffb]

            readdirVV_na3=readdir(hhFolder4,join=true)  ## 4층 100개
            readdirVV_na3=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na3,"AoSIN")
            readdirVV_na3=ChamGoWonsoEreum_jungRyul(readdirVV_na3,1)

            for ffb in 1:length(readdirVV_na3)

                hhFolder3=readdirVV_na3[ffb]

                readdirVV_na2=readdir(hhFolder3,join=true)  ## 4층 100개
                readdirVV_na2=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na2,"AoSIN")
                readdirVV_na2=ChamGoWonsoEreum_jungRyul(readdirVV_na2,1)

                for ffa in 1:length(readdirVV_na2)

                    hhFolder2=readdirVV_na2[ffa]
        
                    ####### 4층 일
                    readdirVV_na=readdir(hhFolder2,join=true)
                    readdirVV_na=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na,"AoSIN")
                    readdirVV_na=ChamGoWonsoEreum_jungRyul(readdirVV_na,1)
                    append!(fileEreumMoum,readdirVV_na)  ## 결결. 붙이기.
                end
            end
        end

    elseif jeCongHhDan==2

        ############# 2층 일
        sang_congEreum3=congEreumRo_sangSeung(jeCong,1)  ## 테이블 층
        readdirVV3=readdir(sang_congEreum3,join=true)  ## 2층 100개
        readdirVV3=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV3,"AoSIN")
        readdirVV3=ChamGoWonsoEreum_jungRyul(readdirVV3,1)

        readdirVV_na3=readdir(readdirVV3[bonFolderBun],join=true)  ## 3층 100개
        readdirVV_na3=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na3,"AoSIN")
        readdirVV_na3=ChamGoWonsoEreum_jungRyul(readdirVV_na3,1)

        for ffb in 1:length(readdirVV_na3)

            hhFolder3=readdirVV_na3[ffb]

            readdirVV_na2=readdir(hhFolder3,join=true)  ## 4층 100개
            readdirVV_na2=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na2,"AoSIN")
            readdirVV_na2=ChamGoWonsoEreum_jungRyul(readdirVV_na2,1)

            for ffa in 1:length(readdirVV_na2)

                hhFolder2=readdirVV_na2[ffa]
    
                ####### 4층 일
                readdirVV_na=readdir(hhFolder2,join=true)
                readdirVV_na=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na,"AoSIN")
                readdirVV_na=ChamGoWonsoEreum_jungRyul(readdirVV_na,1)
                append!(fileEreumMoum,readdirVV_na)  ## 결결. 붙이기.
            end
        end

    elseif jeCongHhDan==3

        ########## 3층 일
        sang_congEreum2=congEreumRo_sangSeung(jeCong,1)  ## 2층
        readdirVV2=readdir(sang_congEreum2,join=true)  ## 3층 100개
        readdirVV2=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV2,"AoSIN")
        readdirVV2=ChamGoWonsoEreum_jungRyul(readdirVV2,1)

        readdirVV_na2=readdir(readdirVV2[bonFolderBun],join=true)  ## 4층 100개
        readdirVV_na2=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na2,"AoSIN")
        readdirVV_na2=ChamGoWonsoEreum_jungRyul(readdirVV_na2,1)

        for ffa in 1:length(readdirVV_na2)

            hhFolder2=readdirVV_na2[ffa]

            ####### 4층 일
            readdirVV_na=readdir(hhFolder2,join=true)
            readdirVV_na=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na,"AoSIN")
            readdirVV_na=ChamGoWonsoEreum_jungRyul(readdirVV_na,1)
            append!(fileEreumMoum,readdirVV_na)  ## 결결. 붙이기.
        end

    elseif jeCongHhDan==4  ## 마지막 4층 폴더시

        ####### 4층 일
        sang_congEreum1=congEreumRo_sangSeung(jeCong,1)
        readdirVV=readdir(sang_congEreum1,join=true)
        readdirVV=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV,"AoSIN")
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        readdirVV_na=readdir(readdirVV[bonFolderBun],join=true)
        readdirVV_na=stringBB_wonsoJoong_ttunString_poham_wonso_jeguBB(readdirVV_na,"AoSIN")
        readdirVV_na=ChamGoWonsoEreum_jungRyul(readdirVV_na,1)
        append!(fileEreumMoum,readdirVV_na)  ## 결결. 붙이기.
    end

    return fileEreumMoum
end




################ jls 퍄일 총 이름들 입력받으면 푼 df 하나 반환
function fileCongEreumDleRo_dfHana(fileCongEreumMoum)

    ffa=1
 
    df_punHana=deserialize(fileCongEreumMoum[ffa])
    # ## 결. df 하나 최초 마련

    for ffa in 2:length(fileCongEreumMoum)

        hhPunDf=deserialize(fileCongEreumMoum[ffa])

        append!(df_punHana,hhPunDf)  ## 결. df 하나에 붙이기.
    end

    return df_punHana
end




################ 특수목적 macjangFolderCong 이름을 순차적으로 변경하기 위한 것
function folderCongBB_ttunBunEhu_sujung_teuc(folderCongBB,ttunBun,sujungHalFolderEreum)

    sujungHalFolderEreum_splitVV=split(sujungHalFolderEreum,"\\")

    for ffa in ttunBun:length(folderCongBB)

        hhFolderCong=folderCongBB[ffa]
        hhFolderCong_spitVV=split(hhFolderCong,"\\")

        for ffb in 1:length(sujungHalFolderEreum_splitVV)

            if hhFolderCong_spitVV[ffb] !=sujungHalFolderEreum_splitVV[ffb]

                hhFolderCong_spitVV[ffb]=sujungHalFolderEreum_splitVV[ffb]
                # ## 결. 수정.
            end
        end

        se_hhFolderCong=stringBB_gyungroHab(hhFolderCong_spitVV)
        folderCongBB[ffa]=se_hhFolderCong  ## 수정 배치
    end

    return folderCongBB
end




################ "v" 로 나눠져 있는 참고원소이름 을 정정렬 또는 역정렬 하는 것.
# ChamGoWonsoEreum_jungRyul 본체
function ChamGoWonsoEreum_jungRyul(wonsoEreumBB,jungNaYuc)
    # ## 정정렬이나 역정렬- 1 정정렬, 2역정렬

    if length(wonsoEreumBB)==0

        return Any[]

    else

        ################# 길이순으로 1차 정렬
        wonsoGiliDle=Vector()

        for ffa in 1:length(wonsoEreumBB)

            hhWonsoGili=length(wonsoEreumBB[ffa])
            push!(wonsoGiliDle,hhWonsoGili)
        end

        df_anne=DataFrame(GILI=wonsoGiliDle,IB=wonsoEreumBB)

        if jungNaYuc==1

            sort!(df_anne,"GILI")

        elseif jungNaYuc==2

            sort!(df_anne,"GILI",rev=true)
        end

        wonsoEreumBB=df_anne[!,"IB"]

        ################# "C:\\ORI" 이럴시 분절수로 2차 정렬
        vv3ChaHu=1  ## 3차 정렬 허가 1로 초기화

        ffa=1
        splitVV=split(wonsoEreumBB[end],"\\")

        if length(splitVV)>=2

            bunjulSu=Vector()

            for ffa in 1:length(wonsoEreumBB)

                splitVV=split(wonsoEreumBB[ffa],"\\")
                hhBunjulSu=length(splitVV)

                push!(bunjulSu,hhBunjulSu)
            end

            if bunjulSu[1] !=bunjulSu[end]  ## 분절수가 다를시

                vv3ChaHu=0  ## 3차 정렬 허가 0 처리
            end

            df_anne=DataFrame(SU=bunjulSu,IB=wonsoEreumBB)

            if jungNaYuc==1

                sort!(df_anne,"SU")

            elseif jungNaYuc==2

                sort!(df_anne,"SU",rev=true)
            end

            wonsoEreumBB=df_anne[!,"IB"]
        end

        #
        ################# 참고원소이름 규칙에 따라 3차 정렬
        if vv3ChaHu==1  ## 허가 있을 시만 통과

            sanHu=0

            ############### 마지막 검사 
            # "C:\\ChamGo\\ADGO_2_JJOIL_TS_SL01_WONCHEON\\WON_IDv1v1599763\\WON_IDv1v1599763\\AoSIN\\AoSIN"
            splitVV=split(wonsoEreumBB[end],"\\")
            splitVV2=split(splitVV[end],"v")

            if length(splitVV2)>=2

                sanHu=1  ## 참고원소이름 규칙을 따르면 산출 허가
            end

            ############### 산출
            if sanHu==1  ## 허가시만

                anneGabDle=Vector()

                for ffa in 1:length(wonsoEreumBB)

                    splitVV=split(wonsoEreumBB[ffa],"v")

                    findlastVV1=findlast("AoSIN",splitVV[end])

                    if findlastVV1==nothing

                        findlastVV=findlast(".cs",splitVV[end])        

                        if findlastVV==nothing

                            hhAnneGab=parse(Float64,splitVV[end])

                        else

                            splitVV2=split(splitVV[end],".")
                            hhAnneGab=parse(Float64,splitVV2[1])
                        end

                        push!(anneGabDle,hhAnneGab)  ## "ID","1001" 이런식으로 돼 있는데서 
                        # "1001" 숫자로 만들어 붙임.

                    else  ## "AoSIN" 있을 경우 

                        hhAnneGab=-Inf  ## 맨 처음으로 배치
                        push!(anneGabDle,hhAnneGab) 
                    end
                end

                df_anne=DataFrame(ANNEGAB=anneGabDle,IB=wonsoEreumBB)

                if jungNaYuc==1

                    sort!(df_anne,"ANNEGAB")

                elseif jungNaYuc==2

                    sort!(df_anne,"ANNEGAB",rev=true)
                end

                jungRyulDoin_wonsoEreumBB=copy(df_anne[:,"IB"])  ## 종. 3차까지 정렬된

            else

                jungRyulDoin_wonsoEreumBB=copy(wonsoEreumBB)
            end

        else

            jungRyulDoin_wonsoEreumBB=copy(wonsoEreumBB)
        end

        return jungRyulDoin_wonsoEreumBB
    end
end




################ 지정한 색인의 저장된 최대값 - select Max()
function secinDeGab(goTableEreum::String,secin::String)

    readdirVV=readdir(ChamGoIbguCong)

    if goTableEreum ∈ readdirVV  ## 테이블이 있으면 통과

        goTableEreumCong=ChamGoIbguCong*"\\"*goTableEreum

        readdirVV=readdir(goTableEreumCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        ############# 본격 - 맨 마지막 폴더 읽어서 df_wonsoEreum 풀어서.
        if readdirVV[end] !="AoSIN"

            hh_readdirVV_end=readdirVV[end]

        else

            hh_readdirVV_end=readdirVV[end-1]
        end

        df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(hh_readdirVV_end)

        ceDeGab=0  ## 0으로 초기화

        for ffa in 1:nrow(df_wonsoEreum)

            if df_wonsoEreum[ffa,"SECIN"]==secin

                ceDeGab=df_wonsoEreum[ffa,"MACGAB"]
                break
            end
        end

        return ceDeGab

    else  ## 테이블 자체가 없으면 0 반환
        
        return 0
    end
end




################
function AoSIN_folder_sacje(tableFolderCong)

    hhCong=tableFolderCong

    for ffa in 1:goGibe

        readdirVV=readdir(hhCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        if "AoSIN" ∈ readdirVV

            rmFileCong=hhCong*"\\"*"AoSIN"
            rm(rmFileCong,recursive=true)  ## 결. 삭제. 하위 폴더까지 다 삭제함. # 총 자체 폴더 삭제함.

            break

        else

            hhCong*="\\"
            hhCong*=readdirVV[end]
        end
    end
end




################ 막행부터 앞으로 가며 삭제 
# - 기술: 막행부터 앞으로 가며 삭제함. 퍄일 1개 삭제후 폴더명 정비를 반복하다 
# 유지최대값 만나면 종료함. 유지최대값 있는 퍄일 까지 삭제후 폴더명 정비후 
# 유지최대값 만큼 1~2행 정도 쓰기하고 마무리.
# 사용 유
function macHengButu_sacje(goHyung,goTableEreum::String,secin::String,ujiDeGab)
    # ## 색인의 유지최대값 초과하는 행들은 삭제됨.
    println("function macHengButu_sacje 시작")

    secinDeGabVV=secinDeGab(goTableEreum,secin)

    if ujiDeGab<secinDeGabVV  ## 삭제 조건이 맞을 시만 통과

        tableFolderCong=ChamGoIbguCong*"\\"*goTableEreum  ## "C:\\ChamGo\\Table" 총이름

        AoSIN_folder_sacje(tableFolderCong)
   
        ######################## AoSIN 폴더 삭제 이후
        whileheureum=1
        wwa=0

        while true

            wwa+=1
            println("function macHengButu_sacje 와일 wwa=$wwa 회")

            ##################
            macjangFolderCong_jaryoMan=tableFolderRo_macjangFolderCong(tableFolderCong)
            # ## 결. 자료만 막장 폴더 총이름.

            ##################
            macjangFileDle=readdir(macjangFolderCong_jaryoMan[end])
            macjangFileDle=ChamGoWonsoEreum_jungRyul(macjangFileDle,1)

            hhMacFile=macjangFileDle[end]  ## 결. 대상인 막장의 마지막 퍄일.
            hhMacFileCong=macjangFolderCong_jaryoMan[end]*"\\"*hhMacFile  ## 결.
            hhMacFile_df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(hhMacFile)
            # ## ["SECIN","JACGAB","MACGAB"]

            hhSecinBB=hhMacFile_df_wonsoEreum[:,"SECIN"]

            ################## 막장 마지막 퍄일이 삭제 필요한지 흐름 판단부
            hhMacFileheureum=0

            for ffa in 1:nrow(hhMacFile_df_wonsoEreum)

                if hhMacFile_df_wonsoEreum[ffa,"SECIN"]==secin

                    if ujiDeGab<hhMacFile_df_wonsoEreum[ffa,"JACGAB"]

                        hhMacFileheureum=10  ## 삭제만 필요 10 부여

                    elseif hhMacFile_df_wonsoEreum[ffa,"JACGAB"]<=ujiDeGab<=hhMacFile_df_wonsoEreum[ffa,"MACGAB"]

                        hhMacFileheureum=101  ## 삭제후 일부행을 다시 쓰기 필요 101 부여

                    elseif hhMacFile_df_wonsoEreum[ffa,"MACGAB"]<ujiDeGab  ## 무일 혹시나 갈래 - 삭제 불필요

                        ################## 신 폴더 생성부 - 필요시만 생성함.
                        macjangFolderCong_jaryoMan=tableFolderRo_macjangFolderCong(tableFolderCong)
                        sinFolder_sung(macjangFolderCong_jaryoMan)  ## 종. AoSIN 폴더 생성.

                        whileheureum=-1004
                        break
                    end
                end
            end

            ################## 삭제할 퍄일이 그 폴더의 마지막 퍄일인지
            hhFolderMacFile=0  ## 일상 0 부여

            if length(macjangFileDle)==1

                hhFolderMacFile=1  ## 마지막 퍄일만 있는 경우 1 부여
            end

            #
            ################## 흐름 판단이후 본격 - 삭제 후 폴더 이름 쭉 수정
            if hhMacFileheureum==10  ## 삭제만 할 갈래

                ################ 삭제
                if hhFolderMacFile==0  ## 일상 갈래

                    ################ 새로 쓸 폴더 이름 쭉 마련
                    hhssjulDesang=macjangFileDle[end-1] 
                    hhssjulDesang_df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(hhssjulDesang)

                    ################ 막값들 모으기
                    macGabDle=Vector()

                    for ffa in 1:nrow(hhssjulDesang_df_wonsoEreum)

                        hhGab=hhssjulDesang_df_wonsoEreum[ffa,"MACGAB"]
                        push!(macGabDle,hhGab)  ## 막값들
                    end

                    ################ 새로 쓸 이름 마련 이후 삭제할 것 삭제
                    rm(hhMacFileCong)  ## 종. 삭제.

                    ################ 종결. 폴더 이름 쭉 수정하기
                    folderDle_ereumJe(macjangFolderCong_jaryoMan,hhSecinBB,macGabDle)

                elseif hhFolderMacFile==1  ## 제2 갈래

                    rm(hhMacFileCong)  ## 종. 삭제.

                    ################ 폴더 삭제
                    for ffa in length(macjangFolderCong_jaryoMan):-1:2

                        hhDocFolder=macjangFolderCong_jaryoMan[ffa]
                        readdirVV2=readdir(hhDocFolder)

                        if length(readdirVV2)==0

                            rm(hhDocFolder)
                            # ## 종. 마지막 퍄일 있던 폴더 삭제.
                        end
                    end

                    ################
                    macjangFolderCong_jaryoMan=tableFolderRo_macjangFolderCong(tableFolderCong)

                    hhssjulDesang_df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(macjangFolderCong_jaryoMan[end])

                    ################ 막값들 모으기
                    macGabDle=Vector()

                    for ffa in 1:nrow(hhssjulDesang_df_wonsoEreum)

                        hhGab=hhssjulDesang_df_wonsoEreum[ffa,"MACGAB"]
                        push!(macGabDle,hhGab)  ## 막값들
                    end

                    ################ 종결. 폴더 이름 쭉 수정하기
                    folderDle_ereumJe(macjangFolderCong_jaryoMan,hhSecinBB,macGabDle)
                end

            elseif hhMacFileheureum==101  ## 삭제 후 써야할 갈래

                ################ 삭제 후 쓸 df 마련 
                hhPunDf=deserialize(hhMacFileCong)

                ceHengBun=1

                for ffa in 1:nrow(hhPunDf)

                    if hhPunDf[ffa,secin]<=ujiDeGab

                        ceHengBun=ffa 

                    else

                        break
                    end
                end

                sacjeHussjulDf=hhPunDf[1:ceHengBun,:]  ## 결. 쓸 df 마련. 

                ################ 삭제
                if hhFolderMacFile==0  ## 일상 갈래

                    ################ 새로 쓸 폴더 이름 쭉 마련
                    hhssjulDesang=macjangFileDle[end-1] 
                    hhssjulDesang_df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(hhssjulDesang)

                    ################ 막값들 모으기
                    macGabDle=Vector()

                    for ffa in 1:nrow(hhssjulDesang_df_wonsoEreum)

                        hhGab=hhssjulDesang_df_wonsoEreum[ffa,"MACGAB"]
                        push!(macGabDle,hhGab)  ## 막값들
                    end

                    ################ 새로 쓸 이름 마련 이후 삭제할 것 삭제
                    rm(hhMacFileCong)  ## 종. 삭제.

                    ################ 종결. 폴더 이름 쭉 수정하기
                    folderDle_ereumJe(macjangFolderCong_jaryoMan,hhSecinBB,macGabDle)

                elseif hhFolderMacFile==1  ## 제2 갈래

                    rm(hhMacFileCong)  ## 종. 삭제.

                    ################ 폴더 삭제
                    for ffa in length(macjangFolderCong_jaryoMan):-1:2

                        hhDocFolder=macjangFolderCong_jaryoMan[ffa]
                        readdirVV2=readdir(hhDocFolder)

                        if length(readdirVV2)==0

                            rm(hhDocFolder)
                            # ## 종. 마지막 퍄일 있던 폴더 삭제.
                        end
                    end

                    ################
                    macjangFolderCong_jaryoMan=tableFolderRo_macjangFolderCong(tableFolderCong)

                    hhssjulDesang_df_wonsoEreum=ChamGoWonsoEreumRo_wonsoEreumDf(macjangFolderCong_jaryoMan[end])

                    ################ 막값들 모으기
                    macGabDle=Vector()

                    for ffa in 1:nrow(hhssjulDesang_df_wonsoEreum)

                        hhGab=hhssjulDesang_df_wonsoEreum[ffa,"MACGAB"]
                        push!(macGabDle,hhGab)  ## 막값들
                    end

                    ################ 종결. 폴더 이름 쭉 수정하기
                    folderDle_ereumJe(macjangFolderCong_jaryoMan,hhSecinBB,macGabDle)
                end

                ################## 신 폴더 생성부 - 필요시만 생성함.
                macjangFolderCong_jaryoMan=tableFolderRo_macjangFolderCong(tableFolderCong)
                sinFolder_sung(macjangFolderCong_jaryoMan)  ## 종. AoSIN 폴더 생성.

                ################ 삭제 후 다시 쓰기
                dfRoChamGo(goHyung,goTableEreum,sacjeHussjulDf,hhSecinBB)  ## 종결. 다시 쓰기.

                whileheureum=-1004  ## 와일 종료 흐름 부여
            end

            if whileheureum==-1004

                break  ## 와일 브레이크
            end
        end
    end

    println("function macHengButu_sacje 끝")
end




################
# 유지대값 날고 막 아이디를 입력하면 그 이하까지만 남기고 전 세계 삭제하는
# nalGoMacIdRo_segeSacje(1,3525-2)
function nalGoMacIdRo_segeSacje(slIn,ujiNalGoMacId)

    if slIn==1

        hhWonGoEreum=CHg01_sl_woncheonGoEreum
        hhGaji25GoEreum=CHg01_sl_gaji25GoEreum
        hhGaji50GoEreum=CHg01_sl_gaji50GoEreum
        hhGaji100GoEreum=CHg01_sl_gaji100GoEreum
        hhJubGoEreum=CHg01_sl_jubhabGoEreum
        hhNalGoEreum=CHg01_sl_nalGoEreum

    else slIn==2

        hhWonGoEreum=CHg01_in_woncheonGoEreum
        hhGaji25GoEreum=CHg01_in_gaji25GoEreum
        hhGaji50GoEreum=CHg01_in_gaji50GoEreum
        hhGaji100GoEreum=CHg01_in_gaji100GoEreum
        hhJubGoEreum=CHg01_in_jubhabGoEreum
        hhNalGoEreum=CHg01_in_nalGoEreum
    end

    ###################### 유지대값의 원천고 아이디 마련
    ujiDeNalGo=ChamGoRoDf(hhNalGoEreum,ujiNalGoMacId,"<=","NAL_ID","<=",ujiNalGoMacId)
    # ## 유지대값의 날고 읽은 

    ujiDeWonGo=
    ChamGoRoDf(hhWonGoEreum,ujiDeNalGo[1,"SI_WON_ID"],"<=","WON_ID","<=",ujiDeNalGo[1,"MACSI_WON_ID"])
    # ## 유지대값의 원천고 

    ujiDeWonId=ujiDeWonGo[end,"WON_ID"]  ## 결. 유지대값의 원천 아이디 

    #
    ################################# 삭제 본격
    ###################### 원천고 삭제
    hhSacjeDesangGo=hhWonGoEreum
 
    goHyung="WON"
    secin="WON_ID"
    ujiDeGab=ujiDeWonId

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)

    ###################### 가지고 삭제
    hhSacjeDesangGo=hhGaji25GoEreum
    hhSecjeDesangGo_docDf=ChamGoRoDf(hhSacjeDesangGo,ujiDeWonId-10000,"<","SI_WON_ID","<=",ujiDeWonId)

    goHyung="GAJI"
    secin="GAJI25_ID"
    ujiDeGab=hhSecjeDesangGo_docDf[end,secin]

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)

    ###################### 
    hhSacjeDesangGo=hhGaji50GoEreum
    hhSecjeDesangGo_docDf=ChamGoRoDf(hhSacjeDesangGo,ujiDeWonId-10000,"<","SI_WON_ID","<=",ujiDeWonId)

    goHyung="GAJI"
    secin="GAJI50_ID"
    ujiDeGab=hhSecjeDesangGo_docDf[end,secin]

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)

    ###################### 
    hhSacjeDesangGo=hhGaji100GoEreum
    hhSecjeDesangGo_docDf=ChamGoRoDf(hhSacjeDesangGo,ujiDeWonId-10000,"<","SI_WON_ID","<=",ujiDeWonId)

    goHyung="GAJI"
    secin="GAJI100_ID"
    ujiDeGab=hhSecjeDesangGo_docDf[end,secin]

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)

    ###################### 접합고
    hhSacjeDesangGo=hhJubGoEreum
    hhSecjeDesangGo_docDf=ChamGoRoDf(hhSacjeDesangGo,ujiDeWonId-10000,"<","SI_WON_ID","<=",ujiDeWonId)

    goHyung="JUB"
    secin="JUB_ID"
    ujiDeGab=hhSecjeDesangGo_docDf[end,secin]

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)

    ###################### 
    hhSacjeDesangGo=hhNalGoEreum
    hhSecjeDesangGo_docDf=ChamGoRoDf(hhSacjeDesangGo,ujiDeWonId-100000,"<","SI_WON_ID","<=",ujiDeWonId)

    goHyung="NAL"
    secin="NAL_ID"
    ujiDeGab=hhSecjeDesangGo_docDf[end,secin]

    macHengButu_sacje(goHyung,hhSacjeDesangGo,secin,ujiDeGab)
end




################
# 맨 앞 조작만으로 epochms 로 원천고 아이디 찾기 변용 가능.
# dtRoChamGoWoncheonId_dict(hhDt)
function dtRoChamGoWoncheonId_dict(ibDt,slIn=1)
    # ## 실인- 실제원천고냐 인조원천고냐

    ibDt_epochms=Dates.datetime2epochms(ibDt)  
    # ## 이 함축을 epochms 입력으로 하고 싶으면 여기 조작부터가 시작

    ############################# 준비
    if slIn==1

        hhWoncheonGoEreum=CHg01_sl_woncheonGoEreum

    elseif slIn==2

        hhWoncheonGoEreum=CHg01_in_woncheonGoEreum
    end

    woncheon_idSu=secinDeGab(hhWoncheonGoEreum,"WON_ID")

    ################## 와일당 찾을 작아이디 막아이디 부여
    hhWonGoChatJacId=1
    hhWonGoChatMacId=woncheon_idSu

    ############################# 와일 본격
    ceWonGoId=nothing
    ceWonGoEpochms=nothing
    chatheureum=0

    while chatheureum==0

        ################## 독중아이디 산출
        hhWonGoDocJungId=(hhWonGoChatJacId+hhWonGoChatMacId)*0.5
        hhWonGoDocJungId=Int(round(hhWonGoDocJungId))

        ################## 3지점 작,중,막 아이디 epochms 읽기
        hhWonGoChatJacId_docHeng=ChamGoRoDf(hhWoncheonGoEreum,hhWonGoChatJacId,"<=","WON_ID","<=",hhWonGoChatJacId)
        hhWonGoDocJungId_docHeng=ChamGoRoDf(hhWoncheonGoEreum,hhWonGoDocJungId,"<=","WON_ID","<=",hhWonGoDocJungId)
        hhWonGoChatMacId_docHeng=ChamGoRoDf(hhWoncheonGoEreum,hhWonGoChatMacId,"<=","WON_ID","<=",hhWonGoChatMacId)
        
        ################## 3지점 읽은 이후 
        if hhWonGoChatJacId_docHeng[1,"EPOCHMS"]<=ibDt_epochms<hhWonGoDocJungId_docHeng[1,"EPOCHMS"]

            ################## 찾을 작막 아이디 갱신
            hhWonGoChatJacId=hhWonGoChatJacId_docHeng[1,"WON_ID"]
            hhWonGoChatMacId=hhWonGoDocJungId_docHeng[1,"WON_ID"]

        elseif hhWonGoDocJungId_docHeng[1,"EPOCHMS"]<=ibDt_epochms<hhWonGoChatMacId_docHeng[1,"EPOCHMS"]

            ################## 찾을 작막 아이디 갱신
            hhWonGoChatJacId=hhWonGoDocJungId_docHeng[1,"WON_ID"]
            hhWonGoChatMacId=hhWonGoChatMacId_docHeng[1,"WON_ID"]

        elseif ibDt_epochms==hhWonGoChatMacId_docHeng[1,"EPOCHMS"]  ## 찾은

            ################## 
            ceWonGoId=hhWonGoChatMacId_docHeng[1,"WON_ID"]
            ceWonGoEpochms=hhWonGoChatMacId_docHeng[1,"EPOCHMS"]
            chatheureum=1004  ## 다 찾은 1004 부여

            break
        end

        ################## 다음번 찾을 작막 아이디차 범위 산출 판단
        hhWonGoChatIdDul_bumwe=hhWonGoChatMacId-hhWonGoChatJacId  ## 범위 산출

        if hhWonGoChatIdDul_bumwe<=40*4*2

            chatheureum=2
        end
    end

    ############################# 와일 이후 나머지 순차 찾기 
    if chatheureum==2

        ################## 준비
        hhDocWoncheonGo=ChamGoRoDf(hhWoncheonGoEreum,hhWonGoChatJacId,"<=","WON_ID","<=",hhWonGoChatMacId)

        hhDeEpochmsChaJd=Inf
        hhCeWonGoId=nothing
        hhCeWonGoEpochms=nothing

        ################## 포문 본격
        for ffa in 1:nrow(hhDocWoncheonGo)

            hhDocHengEpochms=hhDocWoncheonGo[ffa,"EPOCHMS"]

            hhDocHengEpochmsChaJd=abs(hhDocHengEpochms-ibDt_epochms)

            if hhDocHengEpochmsChaJd==0  ## 차이 0- 찾은

                hhCeWonGoId=hhDocWoncheonGo[ffa,"WON_ID"]
                hhCeWonGoEpochms=hhDocWoncheonGo[ffa,"EPOCHMS"]
                break 

            else  ## 차이 유- 찾는 중

                if hhDeEpochmsChaJd>hhDocHengEpochmsChaJd

                    hhDeEpochmsChaJd=hhDocHengEpochmsChaJd

                    hhCeWonGoId=hhDocWoncheonGo[ffa,"WON_ID"]
                    hhCeWonGoEpochms=hhDocWoncheonGo[ffa,"EPOCHMS"]
                end
            end
        end

        ################## 결. 포문 종료 후 확정
        ceWonGoId=hhCeWonGoId
        ceWonGoEpochms=hhCeWonGoEpochms
    end

    ##################
    ceWonGoEpochmsDt=Dates.epochms2datetime(ceWonGoEpochms)

    ##################
    rra_dict=Dict()

    push!(rra_dict,"GOEREUM"=>hhWoncheonGoEreum)
    push!(rra_dict,"WON_ID"=>ceWonGoId)
    push!(rra_dict,"CE_EPOCHMS"=>ceWonGoEpochms)
    push!(rra_dict,"CE_EPOCHMS_DT"=>ceWonGoEpochmsDt)

    return rra_dict
end




################
# 맨 앞 dtRoChamGoWoncheonId_dict 조작만으로 epochms 로 날고 아이디 찾기 변용 가능.
# dtRoChamGoNalId_dict(hhDt)
function dtRoChamGoNalId_dict(ibDt,slIn=1)

    #################### dt 으로 원천 아이디 찾고 원천에서 할 일
    dtRoChamGoWoncheonId_dictVV=dtRoChamGoWoncheonId_dict(ibDt,slIn)
    jun_won_id=dtRoChamGoWoncheonId_dictVV["WON_ID"]
    # ## 결. 찾을 기준 원천 아이디

    ################
    if slIn==1

        hhWonGoEreum=CHg01_sl_woncheonGoEreum

    elseif slIn==2

        hhWonGoEreum=CHg01_in_woncheonGoEreum
    end

    hhWoncheon_idSu=secinDeGab(hhWonGoEreum,"WON_ID")

    ################
    hhCeWonGoId_biWc=jun_won_id/hhWoncheon_idSu
    # ## 결. 비율 위치 구한. 

    #
    #################### 
    ################
    if slIn==1

        hhNalGoEreum=CHg01_sl_nalGoEreum

    elseif slIn==2

        hhNalGoEreum=CHg01_in_nalGoEreum
    end

    hhNalGo_idSu=secinDeGab(hhNalGoEreum,"NAL_ID")

    hhDocNalGo_idChi=hhNalGo_idSu*hhCeWonGoId_biWc
    hhDocNalGo_idChi=Int(round(hhDocNalGo_idChi))
    # ## 결. 날고에서 읽을 아이디 

    ################
    bunDumGab=600  ## 손잡이

    hhDocNalGo_jacBun=hhDocNalGo_idChi-bunDumGab
    hhDocNalGo_macBun=hhDocNalGo_idChi+bunDumGab
    ## 결. 읽을 날고 작막번 마련. 

    hhDocNalGaji=ChamGoRoDf(hhNalGoEreum,hhDocNalGo_jacBun,"<=","NAL_ID","<=",hhDocNalGo_macBun)

    ################
    ceNalGoId=1004.1004

    for ffa in 1:nrow(hhDocNalGaji)

        hhNalGoHeng=hhDocNalGaji[ffa:ffa,:]  ## 날고 1행인.

        if hhNalGoHeng[1,"SI_WON_ID"]<=jun_won_id<=hhNalGoHeng[1,"MACSI_WON_ID"]

            ceNalGoId=hhNalGoHeng[1,"NAL_ID"]  ## 결. 찾은.
        end
    end
    ## ceNalGoId 산출한. 

    #
    ####################
    rra_dict=Dict()

    push!(rra_dict,"GOEREUM"=>hhNalGoEreum)
    push!(rra_dict,"NAL_ID"=>ceNalGoId)
    push!(rra_dict,"CE_EPOCHMS"=>dtRoChamGoWoncheonId_dictVV["CE_EPOCHMS"])
    push!(rra_dict,"CE_EPOCHMS_DT"=>dtRoChamGoWoncheonId_dictVV["CE_EPOCHMS_DT"])

    return rra_dict
end




################ WON_ID 입력하면 해당하는 NAL_ID 반환
function ChamGoWoncheonIdRo_nalGoId_dict(slIn,ib_won_id)

    ############################# 준비
    if slIn==1

        hhNalGoEreum=CHg01_sl_nalGoEreum

    elseif slIn==2

        hhNalGoEreum=CHg01_in_nalGoEreum
    end

    nalGo_idSu=secinDeGab(hhNalGoEreum,"NAL_ID")

    ################## 와일당 찾을 작아이디 막아이디 부여
    hhNalGoChatJacId=1
    hhNalGoChatMacId=nalGo_idSu

    ############################# 와일 본격
    ceNalGoId=nothing 
    chatheureum=0

    while chatheureum==0

        ################## 독중아이디 산출
        hhNalGoDocJungId=(hhNalGoChatJacId+hhNalGoChatMacId)*0.5
        hhNalGoDocJungId=Int(round(hhNalGoDocJungId))

        ################## 3지점 작,중,막 아이디 일기
        hhNalGoChatJacId_docHeng=ChamGoRoDf(hhNalGoEreum,hhNalGoChatJacId,"<=","NAL_ID","<=",hhNalGoChatJacId)
        hhNalGoDocJungId_docHeng=ChamGoRoDf(hhNalGoEreum,hhNalGoDocJungId,"<=","NAL_ID","<=",hhNalGoDocJungId)
        hhNalGoChatMacId_docHeng=ChamGoRoDf(hhNalGoEreum,hhNalGoChatMacId,"<=","NAL_ID","<=",hhNalGoChatMacId)

        ################## 3지점 읽은 이후 
        if hhNalGoChatJacId_docHeng[1,"SI_WON_ID"]<=ib_won_id<=hhNalGoDocJungId_docHeng[1,"SI_WON_ID"]

            ################## 찾을 작막 아이디 갱신
            hhNalGoChatJacId=hhNalGoChatJacId_docHeng[1,"NAL_ID"]
            hhNalGoChatMacId=hhNalGoDocJungId_docHeng[1,"NAL_ID"]

        elseif hhNalGoDocJungId_docHeng[1,"SI_WON_ID"]<=ib_won_id<hhNalGoChatMacId_docHeng[1,"SI_WON_ID"]

            ################## 찾을 작막 아이디 갱신
            hhNalGoChatJacId=hhNalGoDocJungId_docHeng[1,"NAL_ID"]
            hhNalGoChatMacId=hhNalGoChatMacId_docHeng[1,"NAL_ID"]

        elseif hhNalGoChatMacId_docHeng[1,"SI_WON_ID"]<=ib_won_id<=hhNalGoChatMacId_docHeng[1,"MACSI_WON_ID"]
            # ## 찾은

            ################## 
            ceNalGoId=hhNalGoChatMacId_docHeng[1,"NAL_ID"]
            chatheureum=1004  ## 다 찾은 1004 부여

            break
        end

        ################## 다음번 찾을 작막 아이디차 범위 산출 판단
        hhNalGoChatIdDul_bumwe=hhNalGoChatMacId-hhNalGoChatJacId  ## 범위 산출

        if hhNalGoChatIdDul_bumwe<=3

            chatheureum=2
        end
    end

    ############################# 와일 이후 나머지 순차 찾기 
    if chatheureum==2

        ################## 준비
        hhDocNalGo=ChamGoRoDf(hhNalGoEreum,hhNalGoChatJacId,"<=","NAL_ID","<=",hhNalGoChatMacId)

        ################## 포문 본격
        for ffa in 1:nrow(hhDocNalGo)

            hhDoc_si_won_id=hhDocNalGo[ffa,"SI_WON_ID"]
            hhDoc_macsi_won_id=hhDocNalGo[ffa,"MACSI_WON_ID"]

            if hhDoc_si_won_id<=ib_won_id<=hhDoc_macsi_won_id  

                ceNalGoId=hhDocNalGo[ffa,"NAL_ID"]  ## 결. 찾은.
            end
        end
    end

    ################## 종. 
    rra_dict=Dict()

    push!(rra_dict,"GOEREUM"=>hhNalGoEreum)
    push!(rra_dict,"NAL_ID"=>ceNalGoId)
 
    return rra_dict
end




################ 현재 참고의 마지막 정보 dict() 로 반환 - 실제고용
# ChamGo_sl_macBo_dict(2)
function ChamGo_sl_macBo_dict(wonNaDa=1)
    # ## 원천고만 또는 다

    rra_dict=Dict()

    push!(rra_dict,"ChamGoEreum"=>ChamGoEreum)
    push!(rra_dict,"junsangi_now"=>now())

    #################### 원천고
    ################# 원천고 기반
    hhGoTableEreum=CHg01_sl_woncheonGoEreum
    hhSecin="WON_ID"
    hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

    hhDf=ChamGoRoDf(hhGoTableEreum,hhSecinDeGabVV,"<=",hhSecin,"<=",hhSecinDeGabVV)
    hhMacGi=hhDf[end,"GI"]
    hhEpochms=hhDf[end,"EPOCHMS"]
    hhDt=Dates.epochms2datetime(hhEpochms)

    push!(rra_dict,"WONGO_MAC_WON_ID"=>hhSecinDeGabVV)
    push!(rra_dict,"WONGO_MAC_GI_wonGoBan"=>hhMacGi)
    push!(rra_dict,"WONGO_MAC_EPOCHMS_wonGoBan"=>hhEpochms)
    push!(rra_dict,"WONGO_MAC_DT_wonGoBan"=>hhDt)

    hhEpochms_jigu=hhDf[end,"EPOCHMS_JIGU"]
    hhDt_jigu=Dates.epochms2datetime(hhEpochms_jigu)

    push!(rra_dict,"WONGO_MAC_EPOCHMS_JIGU_wonGoBan"=>hhEpochms_jigu)
    push!(rra_dict,"WONGO_MAC_DT_JIGU_wonGoBan"=>hhDt_jigu)

    ################# 날고 기반
    sl_nal_macId=secinDeGab(CHg01_sl_nalGoEreum,"NAL_ID")

    nalGoMacNal=ChamGoRoDf(CHg01_sl_nalGoEreum,sl_nal_macId,"<=","NAL_ID","<=",sl_nal_macId)

    hhJacId=nalGoMacNal[1,"SI_WON_ID"]
    hhMacId=nalGoMacNal[1,"MACSI_WON_ID"]

    wonGoDoc=ChamGoRoDf(CHg01_sl_woncheonGoEreum,hhJacId,"<=","WON_ID","<=",hhMacId)
    # ## 결. 원천고 읽은

    hhMacGi2=wonGoDoc[end,"GI"]
    hhEpochms2=wonGoDoc[end,"EPOCHMS"]
    hhDt2=Dates.epochms2datetime(hhEpochms2)

    push!(rra_dict,"WONGO_MAC_GI_nalGoBan"=>hhMacGi2)
    push!(rra_dict,"WONGO_MAC_EPOCHMS_nalGoBan"=>hhEpochms2)
    push!(rra_dict,"WONGO_MAC_DT_nalGoBan"=>hhDt2)

    hhEpochms2_jigu=wonGoDoc[end,"EPOCHMS_JIGU"]
    hhDt2_jigu=Dates.epochms2datetime(hhEpochms2_jigu)

    push!(rra_dict,"WONGO_MAC_EPOCHMS_JIGU_nalGoBan"=>hhEpochms2_jigu)
    push!(rra_dict,"WONGO_MAC_DT_JIGU_nalGoBan"=>hhDt2_jigu)
    
    #
    ####################
    if wonNaDa==2  ## 전체 다 할시 
        
        #
        #################### 가지25 고 
        hhGoTableEreum=CHg01_sl_gaji25GoEreum
        hhSecin="GAJI25_ID"
        hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

        push!(rra_dict,"GAJI25GO_MAC_GAJI25_ID"=>hhSecinDeGabVV)

        #################### 가지50 고 
        hhGoTableEreum=CHg01_sl_gaji50GoEreum
        hhSecin="GAJI50_ID"
        hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

        push!(rra_dict,"GAJI50GO_MAC_GAJI50_ID"=>hhSecinDeGabVV)

        #################### 가지50 고 
        hhGoTableEreum=CHg01_sl_gaji100GoEreum
        hhSecin="GAJI100_ID"
        hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

        push!(rra_dict,"GAJI100GO_MAC_GAJI100_ID"=>hhSecinDeGabVV)

        #
        #################### 접합고 
        hhGoTableEreum=CHg01_sl_jubhabGoEreum
        hhSecin="JUB_ID"
        hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

        push!(rra_dict,"JUBGO_MAC_JUB_ID"=>hhSecinDeGabVV)

        #
        #################### 날고 
        hhGoTableEreum=CHg01_sl_nalGoEreum
        hhSecin="NAL_ID"
        hhSecinDeGabVV=secinDeGab(hhGoTableEreum,hhSecin)

        push!(rra_dict,"NALGO_MAC_NAL_ID"=>hhSecinDeGabVV)
    end

    #################### 참고에 록 기록
    readdirVV=readdir(ChamGoIbguCong)

    roc_file_ereum="ChamGo_sl_macBo_dictDle.bb"
    hh_file_cong=ChamGoIbguCong*"\\"*roc_file_ereum

    if roc_file_ereum ∉ readdirVV

        se_bb=[rra_dict]

    elseif roc_file_ereum ∈ readdirVV

        gu_bb=deserialize(hh_file_cong)

        se_bb=copy(gu_bb)
        push!(se_bb,rra_dict)

        rm(hh_file_cong,recursive=true)
    end

    serialize(hh_file_cong,se_bb)  ## 기록

    return rra_dict
end




################
# 답사날들수 입력하면 날고 중 작아이디, 막아이디 반환함.
function ChamGoNalGo_jungJacMacBun(slIn,dabsaNalDleSuFF,kkallinGoMacUmu)
    # ## 입력: 깔린고막유무- 1 유, 2 무

    if kkallinGoMacUmu==1

        tecGoMacBun=secinDeGab(CHg01_sl_nalGoEreum,"NAL_ID")
        hhJacBun=tecGoMacBun-dabsaNalDleSuFF+1

        rra=[slIn,hhJacBun,tecGoMacBun]
        # ## 이 함축 종에서 반환

    elseif kkallinGoMacUmu==2

        ################################## 답사시험 시작번,막번 산출 원
        ################ 앞쪽 준비
        if slIn==1

            duijilNalGoEreum=CHg01_sl_nalGoEreum
            duijilGoJacId=sl_goInjungJacNalBun
            duijilGoMacId=sl_nal_macId=secinDeGab(duijilNalGoEreum,"NAL_ID")

        elseif slIn==2

            duijilNalGoEreum=CHg01_in_nalGoEreum
            duijilGoJacId=in_goInjungJacNalBun
            duijilGoMacId=secinDeGab(duijilNalGoEreum,"NAL_ID")
        end

        ################ 날고번호 뽑기- dabsaNalDleSuFF 는 입력된 손잡이
        hhRandMacBun=duijilGoMacId-dabsaNalDleSuFF+1  
        # ## 작번을 뽑을 거니까 입력 막번을 앞으로 밀어놔야 한다.
        hhRandJacBun=duijilGoJacId

        # humNalGaji_dabsaHumJacBun=rand(hhRandJacBun:hhRandMacBun)
        humNalGaji_dabsaHumJacBun=nansuHana_biyulBs(hhRandJacBun,hhRandMacBun,[2,3,2,1,2,3,4])
        # ## 비율 손잡이
        humNalGaji_dabsaHumMacBun=humNalGaji_dabsaHumJacBun+dabsaNalDleSuFF-1
        ## 결. 답사시험의 작막번 마련.

        rra=[slIn,humNalGaji_dabsaHumJacBun,humNalGaji_dabsaHumMacBun]  
        # ## 이 함축 종에서 반환
    end

    return rra
end




################
function ChamGoNalGo_jacMacBunRo_woncheonDf(janMacBun_rra)

    ################ 자료고명 마련
    if slIn==1

        duijilNalGoEreum=CHg01_sl_nalGoEreum
        duijilWonGoEreum=CHg01_sl_woncheonGoEreum

    elseif slIn==2

        duijilNalGoEreum=CHg01_in_nalGoEreum
        duijilWonGoEreum=CHg01_in_woncheonGoEreum
    end

    ################ 날고 읽기
    hhDocNalGo=ChamGoRoDf(duijilNalGoEreum,janMacBun_rra[2],"<=","NAL_ID","<=",janMacBun_rra[3])
    # ## 결. 날고 읽은 

    ################ 날작막번들 마련- df 안내 행번 준
    hhDuSu=1-hhDocNalGo[1,"SI_WON_ID"]  ## 이걸 더하면 안내 행번이 됨 # 대체로 음양 음 

    dfNalJacMacBunDle=Vector()

    for ffa in 1:nrow(hhDocNalGo)

        hhDfJacBun=hhDocNalGo[ffa,"SI_WON_ID"]+hhDuSu
        hhDfMacBun=hhDocNalGo[ffa,"MACSI_WON_ID"]+hhDuSu

        hhDfJacMacBun=[hhDfJacBun,hhDfMacBun]

        push!(dfNalJacMacBunDle,copy(hhDfJacMacBun))  ## 결. 작막번들 붙이기 # [작번,막번]
    end

    ################ 원천 읽어 df 만들기 
    df_woncheon=
    ChamGoRoDf(duijilWonGoEreum,hhDocNalGo[1,"SI_WON_ID"],"<=","WON_ID","<=",hhDocNalGo[end,"MACSI_WON_ID"])
    # ## 결. 원천 읽은.

    ################
    rra=[dfNalJacMacBunDle,df_woncheon]

    return rra
end




############################################ 참고 예비 ############################################
################ 참고예비 Cgy 전
function ChamGoYebiJun(drive,yebiGoEreum,deungbunFF)
    # ## 입력: 예비할 드라이브,예비할 고이름,각 테이블을 몇 등분할 건지

    global Cgy_ibguCong=drive*":\\"*yebiGoEreum  ## "D:\\ChamGoYebi"

    global Cgy_table_deungbun=deungbunFF
end




################ 깔린 참고의 테이블 폴더들을 그대로 옮기는 것
function Cgy_yebiGo_folderDle_sung(hhTableDle=[])
    # ## 입력: 현재대상테이블들- [CHg01_sl_woncheonGoEreum] 이런식.

    if hhTableDle==[]

        readdirVV=readdir(ChamGoIbguCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        for ffa in 1:length(readdirVV)

            hhMkPathString=Cgy_ibguCong*"\\"*readdirVV[ffa]

            mkpath(hhMkPathString)  ## 결. 만들기  
        end
    else

        for ffa in 1:length(hhTableDle)

            hhTable=hhTableDle[ffa]

            hhMkPathString=Cgy_ibguCong*"\\"*hhTable

            mkpath(hhMkPathString)  ## 결. 만들기  
        end
    end
end




################ 테이블이름 입력하면 그 테이블의 색인대값 반환함
function Cgy_tableEreumRo_pilyoDle(tableEreum)

    splitVV=split(tableEreum,"_")

    if splitVV[end]=="WONCHEON"

        tableHyung="WON"
        idEreum="WON_ID"
        roGoSiSecin=[idEreum]

    elseif splitVV[end]=="GAJI25"

        tableHyung="GAJI"
        idEreum="GAJI25_ID"
        roGoSiSecin=[idEreum,"SI_WON_ID"]

    elseif splitVV[end]=="GAJI50"

        tableHyung="GAJI"
        idEreum="GAJI50_ID"
        roGoSiSecin=[idEreum,"SI_WON_ID"]

    elseif splitVV[end]=="GAJI100"

        tableHyung="GAJI"
        idEreum="GAJI100_ID"
        roGoSiSecin=[idEreum,"SI_WON_ID"]

    elseif splitVV[end]=="JUBHAB"

        tableHyung="JUB"
        idEreum="JUB_ID"
        roGoSiSecin=[idEreum,"SI_WON_ID"]

    elseif splitVV[end]=="NAL"

        tableHyung="NAL"
        idEreum="NAL_ID"
        roGoSiSecin=[idEreum,"SI_WON_ID"]
    
    elseif splitVV[end]=="ICGE"

        tableHyung="MIPADO"
        idEreum="ANNE"
        roGoSiSecin=[idEreum]
    end

    secinDeGabVV=secinDeGab(tableEreum,idEreum)

    return [tableHyung,idEreum,secinDeGabVV,roGoSiSecin]
end




################ 입력받은 테이블을 예비하는 것
function Cgy_roYebi(hhTableDle=[])
    println("function Cgy_roYebi 시작")

    #########################
    if hhTableDle==[]

        readdirVV=readdir(ChamGoIbguCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        halTableDle=copy(readdirVV)

    else

        halTableDle=copy(hhTableDle)
    end

    #########################
    for ffa in 1:length(halTableDle)

        ################### 준비
        hhTableEreum=halTableDle[ffa]

        println("Cgy_roYebi ffa=$ffa 회 / hhTableEreum=$hhTableEreum")

        Cgy_tableEreumRo_pilyoDleVV=Cgy_tableEreumRo_pilyoDle(hhTableEreum)
        # ## 결. ["GAJI","GAJI100_ID",1234556]
        hhTable_idEreum=Cgy_tableEreumRo_pilyoDleVV[2]
        hhTable_secinDeGab=Cgy_tableEreumRo_pilyoDleVV[3]

        ############### 포문 회전수 구하기
        hanHoiMucSu=hhTable_secinDeGab/Cgy_table_deungbun  ## 결. 한회당 묶을 수.
        hanHoiMucSu=Int(ceil(hanHoiMucSu))

        divremVV=divrem(hhTable_secinDeGab,hanHoiMucSu)

        if divremVV[2]==0

            forHoiJunSu=divremVV[1]

        else

            forHoiJunSu=divremVV[1]+1
        end
        ## 포문 회전수 구한.
        
        for ffb in 1:forHoiJunSu

            ############### 테이블 읽을 작막번 산출 - 참고는 테이블 막번 넘어도 됨.
            hhDocJacBun=hanHoiMucSu*(ffb-1)+1
            hhDocMacBun=hanHoiMucSu*ffb

            hhTableJungDoc=ChamGoRoDf(hhTableEreum,hhDocJacBun,"<=",hhTable_idEreum,"<=",hhDocMacBun)
            # ## 결. 테이블 중에서 작막번으로 끊어 읽은.

            hhCongCong=Cgy_ibguCong*"\\"*hhTableEreum*"\\"*"$ffb"*".Cgy"
            # ## 결. "D:\\ChamGoYebi\\ADGO_2_JJOIL_TS_SL01_WONCHEON\\1.Cgy"

            println("Cgy_roYebi ffb=$ffb 회 / 현재총총=$hhCongCong / 시작")

            serialize(hhCongCong,hhTableJungDoc)  ## 종. 예비 로고.

            println("Cgy_roYebi ffb=$ffb 회 / 현재총총=$hhCongCong / 막")
        end
    end

    println("function Cgy_roYebi 끝")
end




################ 종. 테이블 이름 입력하여 예비. # 입력 안하면 전체 테이블 예비함.
function Cgy_tableDleRoYebi(hhTableDle=[])
    println("function Cgy_tableDleRoYebi 시작")

    Cgy_yebiGo_folderDle_sung(hhTableDle)
    Cgy_roYebi(hhTableDle)

    println("function Cgy_tableDleRoYebi 끝")
end




################ 예비에서 다시 정식 참고로 복원
function Cgy_yebiRoChamGo(hhTableDle=[])
    println("function Cgy_yebiRoChamGo 시작")

    #########################
    if hhTableDle==[]

        readdirVV=readdir(Cgy_ibguCong)
        readdirVV=ChamGoWonsoEreum_jungRyul(readdirVV,1)

        halTableDle=copy(readdirVV)

    else

        halTableDle=copy(hhTableDle)
    end

    #########################
    for ffa in 1:length(halTableDle)

        ################### 준비
        hhTableEreum=halTableDle[ffa]

        println("Cgy_yebiRoChamGo ffa=$ffa 회 / hhTableEreum=$hhTableEreum")

        Cgy_tableEreumRo_pilyoDleVV=Cgy_tableEreumRo_pilyoDle(hhTableEreum)
        # ## 결. ["GAJI","GAJI100_ID",1234556]

        ############## 테이블 총 읽기 - ["1","2","3",...]
        hhTableCong=Cgy_ibguCong*"\\"*hhTableEreum
        readdirVV2=readdir(hhTableCong)  ## "10.Cgy","11.Cgy"
        readdirVV2=ChamGoWonsoEreum_jungRyul(readdirVV2,1)
        hhTableDeBun=length(readdirVV2)  ## 결. 몇 개 퍄일이 있나. 
        # # 모든 참고예비 퍄일은 1,2,3,... 순서이니까.

        for ffb in 1:hhTableDeBun

            hhFileManEreum=readdirVV2[ffb]
            hhDocDfFileEreum=hhTableCong*"\\"*hhFileManEreum
            # ## 결. "D:\\ChamGoYebi\\ADGO_2_JJOIL_TS_SL01_WONCHEON\\1.Cgy"

            println("Cgy_yebiRoChamGo ffb=$ffb 회 / hhDocDfFileEreum=$hhDocDfFileEreum / 시작")

            hhDocDfFile=deserialize(hhDocDfFileEreum)  ## 결. 퍄일 읽은.

            dfRoChamGoVV=
            dfRoChamGo(Cgy_tableEreumRo_pilyoDleVV[1],hhTableEreum,hhDocDfFile,Cgy_tableEreumRo_pilyoDleVV[4])
            # ## 종. 로고한.

            println("Cgy_yebiRoChamGo ffb=$ffb 회 / hhDocDfFileEreum=$hhDocDfFileEreum / 막")
        end
    end

    println("function Cgy_yebiRoChamGo 끝")
end




################
function nalGoNal_idRo_woncheonDf(slIn,ib_nal_id)

    if slIn==1

        hhDocNalGoEreum=CHg01_sl_nalGoEreum
        hhDocWoncheonGoEreum=CHg01_sl_woncheonGoEreum

    elseif slIn==2

        hhDocNalGoEreum=CHg01_in_nalGoEreum
        hhDocWoncheonGoEreum=CHg01_in_woncheonGoEreum
    end

    hhDocNalGo=ChamGoRoDf(hhDocNalGoEreum,ib_nal_id,"<=","NAL_ID","<=",ib_nal_id)

    ################
    hhDocWoncheonGo=ChamGoRoDf(hhDocWoncheonGoEreum,
    hhDocNalGo[1,"SI_WON_ID"],"<=","WON_ID","<=",hhDocNalGo[1,"MACSI_WON_ID"])

    return hhDocWoncheonGo
end




################
function nalGoMacId_sunhumNalSu_boonjulRo_nalJacMacBunDulDle(sunhumNalSu,boonjul=9)

    tecNalGoMacBun=secinDeGab(CHg01_sl_nalGoEreum,"NAL_ID")

    joon_nalJacMacBunCha=Int(ceil(sunhumNalSu/boonjul))

    nalGoJacBun=tecNalGoMacBun-(sunhumNalSu-1)

    ################
    hhNalJacMacBunDulDle=Vector()
  
    for ffa in nalGoJacBun:joon_nalJacMacBunCha:tecNalGoMacBun
       
        hhNalGoJacBun=ffa
        hhNalGoMacBun=hhNalGoJacBun+(joon_nalJacMacBunCha-1)

        if hhNalGoMacBun>tecNalGoMacBun

            hhNalGoMacBun=tecNalGoMacBun
        end

        hhNalJacMacBunDul=[hhNalGoJacBun,hhNalGoMacBun]
        push!(hhNalJacMacBunDulDle,copy(hhNalJacMacBunDul))
    end

    return hhNalJacMacBunDulDle
end




################
function sunhum_nal_id_nalRoc_folderDoc_hal_nal_id_maryeun(sunhum_folderEreum,jac_nal_id,mac_nal_id)

    readdirVV=readdir(ChamGoIbguCong)
    sunhum_folder_cong="$(ChamGoIbguCong)\\$(sunhum_folderEreum)"

    if sunhum_folderEreum ∉ readdirVV

        mkpath(sunhum_folder_cong)  ## 결. 만들기 

        ################
        ce_nal_id=rand(jac_nal_id:mac_nal_id)
        
        return ce_nal_id
    end
    ## 선험 폴더 있는.

    #
    ################ nal_id 모으기
    roc_fileDle=readdir(sunhum_folder_cong)

    hh_roc_nal_idDle=Vector()
 
    for ffa in 1:length(roc_fileDle)
        
        ################
        hh_roc_fileEreum=roc_fileDle[ffa]
        splitVV=split(hh_roc_fileEreum,".")
        splitVV2=split(splitVV[1],"_")

        hh_roc_nal_id=parse(Int,splitVV2[end])  ## 결.
        push!(hh_roc_nal_idDle,hh_roc_nal_id)
    end

    ################
    nalRocDle_df=DataFrame(nal_id=hh_roc_nal_idDle)
    sort!(nalRocDle_df,"nal_id")

    nal_idDle=copy(nalRocDle_df[:,"nal_id"])  ## 결.

    #
    ################
    ce_nal_id=nothing 

    for ffa in 1:30

        nal_id_rand=rand(jac_nal_id:mac_nal_id)

        if nal_id_rand ∉ nal_idDle

            ce_nal_id=nal_id_rand
        end
    end

    ################
    if ce_nal_id==nothing

        ffa2=1

        for ffa in jac_nal_id:mac_nal_id

            ffa2+=1

            ################
            if ffa2<=length(nal_idDle)

                hh_nal_id_dulCha=nal_idDle[ffa2]-nal_idDle[ffa2-1]

                if hh_nal_id_dulCha>=2

                    ce_nal_id=nal_idDle[ffa2-1]+1  ## 결.
                end

            else

                ce_nal_id=nal_idDle[end]+1
            end

            ################
            if ce_nal_id !=nothing

                break
            end
        end
    end

    return ce_nal_id
end




################ 참고예비 끄적
"""
######### 삭제
goHyung="MIPADO"
goTableEreum="ADGO_2_JJOIL_TS_MIPADO_ICGE"
secin="ANNE"
ujiDeGab=40
macHengButu_sacje(goHyung,goTableEreum,secin,ujiDeGab)

######### 참고에서 예비 퍄일들로
ChamGoJun(junsangi,ChamGoEreum,100,4)
ChamGoYebiJun("D","ChamGoYebi_jjEuro",20)
Cgy_tableDleRoYebi([CHg01_sl_gaji25GoEreum,CHg01_sl_gaji50GoEreum,CHg01_sl_gaji100GoEreum,CHg01_sl_jubhabGoEreum,CHg01_sl_nalGoEreum])  
# ## hhTableDle=[]

######### 참고예비에서 정식 참고로
ChamGoJun(junsangi,ChamGoEreum,100,4)
ChamGoYebiJun("D","ChamGoYebi_jjEuro",20)  ## "B:\\ChamGoYebi_jjGold" 폴더에 예비 퍄일이 모두 있어야 함.
Cgy_yebiRoChamGo([CHg01_sl_gaji100GoEreum,CHg01_sl_jubhabGoEreum,CHg01_sl_nalGoEreum])  ## hhTableDle=[]
"""

