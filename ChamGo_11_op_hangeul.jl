

"""
2022년 9월 1일. 오전 11시51분. - copy 점검 완료.
"""




################ 전 일 - 최초 켰다시 할 일
function 참고전(전산기,고이름::String,고묶개수변수=100,고깊이변수=4)
    println("function 참고전 시작")

    ##################
    if 전산기==1

        전산기Drive="D:"

    elseif 전산기==2

        전산기Drive="B:"

    elseif 전산기==3

        전산기Drive="D:"
    end

    ##################
    readdirVV=readdir(전산기Drive)

    if 고이름 ∉ readdirVV

        현MkPathString=전산기Drive*"\\"*고이름
        mkpath(현MkPathString)  ## 결. 만들기  
    end

    global 참고입구총=전산기Drive*"\\"*고이름

    ##################
    global 고묶개수=고묶개수변수  ## 묶음 개수- 막장 폴더 1개에 배치되는 퍄일의 수
    global 고깊이=고깊이변수  ## 깊이- 
    # t3(테이블에서 3계단 더 있는데가 마지막 폴더 있는곳. 퍄일은 4층에 있는 것이 됨.)

    println("function 참고전 막")
end




################ 테이블 폴더가 없을시 만들기 - 테이블 폴더 경로 반환
function 테이블폴더성(고테이블이름::String,고깊이=2)
    # ## 입력: 깊이- t2(테이블에서 2계단 더 있는데가 마지막 폴더 있는곳)
    println("function 테이블폴더성 시작")

    readdirVV=readdir(참고입구총)
    readdirVV=참고원소이름_정률(readdirVV,1)

    if 고테이블이름 ∉ readdirVV  ## 없을 시만 만들기

        mkpathString=참고입구총*"\\"*고테이블이름  
        # ## "C:\\참고\\테이블" 총이름

        for ffa in 1:고깊이  ## 깊이 만큼 마련

            mkpathString*="\\Ao신"
        end

        mkpath(mkpathString)  ## 결. 만들기  
    end

    테이블폴더총=참고입구총*"\\"*고테이블이름  ## "C:\\참고\\테이블" 총이름

    println("function 테이블폴더성 막")
    return 테이블폴더총 
end




################ 테이블 폴더 총이름 입력하면 막장 총이름 반환
function 테이블폴더로_막장폴더총(테이블폴더총)
    println("function 테이블폴더로_막장폴더총 시작")

    막장폴더총=Vector()

    현총=테이블폴더총
    push!(막장폴더총,현총)  ## 결. ["C:\\참고\\테이블"] 최초 붙이기

    for ffa in 1:고깊이

        readdirVV=readdir(현총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        if "Ao신" ∈ readdirVV

            현총*="\\Ao신"
            push!(막장폴더총,현총)  ## 결.

        else  ## 신 폴더 없을시 읽은것중 마지막 폴더 이름 붙임

            if length(readdirVV)>=1  ## ["IDv10000v10001"] 있을 시

                현총*="\\"
                현총*=readdirVV[end]
                push!(막장폴더총,현총)  ## 결.
            end
        end
    end

    println(막장폴더총[end])
    println("function 테이블폴더로_막장폴더총 막")
    return 막장폴더총  ## 막장 폴더 총이름 - 깊이 3이면 길이 4가 됨.
    # # "C:\\참고\\Ao신\\Ao신" # "C:\\참고\\id_1_10000\\id_9900_10000"
end




################ 참고원소이름 을 풀어서 정리한 df로 - 이름 1개(1행)가 df 1개가 됨.
function 참고원소이름로_원소이름Df(참고원소이름)
  
    splitVV1=split(참고원소이름,"\\")
    # ## 참고원소이름="C:\\참고\\ORI고\\ID,1,1000040,EPOCHMS,2001,1002040" 
    # 이런식으로 생겼기 때문에.

    splitVV=split(splitVV1[end],"v")  ## 결. "v" 손잡이- 구별자
    
    색인수=length(splitVV)/3
    secun수=Int(로und(색인수))

    나mesVV=["색인","작값","막값"]
    df_원소이름=binDf_성(나mesVV)

    for ffa in 1:secun수

        현색인번=1+(3*(ffa-1))
        현초값번=현색인번+1
        현막값번=현색인번+2

        현초값번값=parse(Int,splitVV[현초값번])  ## 정수만 됨.

        findlastVV=findlast(".cs",splitVV[현막값번])     

        if findlastVV==nothing

            현값=splitVV[현막값번]

        else

            splitVV2=split(splitVV[현막값번],".")
            현값=splitVV2[1]
        end
        
        현막값번값=parse(Int,현값)
        현BB=[splitVV[현색인번],현초값번값,현막값번값]

        push!(df_원소이름,현BB)
        # ## 결결. 붙이기. ["문자",정수,정수] # 색인은 정수만 됨.
    end

    return df_원소이름  ## ["색인","작값","막값"]
end




################ 원소이름 df(string,Int,Int) 를 참고원소이름(string)으로 만들어 반환
function 원소이름Df로_참고원소이름(df_원소이름)

    sizeVV=size(df_원소이름)

    참고원소이름=""  ## 결. 최초 생성

    for ffa in 1:nrow(df_원소이름)  ## 세로로 행 순

        for ffb in 1:sizeVV[2]  ## 가로로 컬럼 순

            현값=df_원소이름[ffa,ffb]  ## ["ID"]

            if ffa==1 && ffb==1  ## 최초시만 구별자 "v" 없이.

                참고원소이름*=string(현값)  ## 붙이기.

            else  ## 최초 아닐시 구별자 "v" 붙여서

                참고원소이름*="v"
                참고원소이름*=string(현값)  ## 붙이기.
            end
        end
    end

    return 참고원소이름  ## "IDv10000v10010vEPOCHMSv12345v12346"
end




################ 원소이름 df 입력하면 그 중 막값만 수정하는 것.
function 원소이름Df_막값수정(df_원소이름,할값들)
    # ## 입력:수정할 값들=["ID",막값(1010)] 
   
    색인들=할값들[1]
    막값들=할값들[2]

    for ffa in 1:length(색인들)  ## 세로 행

        if df_원소이름[ffa,1]==색인들[ffa]  ## 색인이 같을시

            df_원소이름[ffa,3]=막값들[ffa]  ## 결. 막값 수정.
        end
    end

    return df_원소이름
end




################ 폴더 이름을 참고원소이름으로 수정하는 것
function 폴더들_이름Je(막장폴더총,색인,막값들)
    # ## 입력: 최초유무- 1 최초, 2 최초 아닌 
   
    for ffa in length(막장폴더총):-1:2
        # ## 현막장총 폴더에서 현재 이름, 바꿀 이름을 마련하고 
        # 그 후 1계단 상위 폴더로 올라가서 바꾼다. 그러니 2까지.

        현막장폴더총=막장폴더총[ffa]
        splitVV=split(현막장폴더총,"\\")

        if splitVV[end]=="Ao신"  ## 폴더명이 Ao신 으로 존재할때 갈래

            readdirVV=readdir(현막장폴더총)

            splitVV=split(readdirVV[1],".")  ## ".cs" 자르기

            수정대상폴더이름=막장폴더총[ffa]
            수정할폴더이름=막장폴더총[ffa-1]*"\\"*splitVV[1]

            # cd(참고입구총)
            Base.Filesystem.re나me(수정대상폴더이름,수정할폴더이름)  ## 종. 폴더 이름 수정.

            막장폴더총=
            폴더총BB_떤번이후_수정_특(막장폴더총,ffa,수정할폴더이름)
            # ## 결. 막장폴더총 변수 수정된 이름으로.

        else  ## 폴더명이 Ao신 이 아니라 기 존재시 갈래

            수정대상폴더이름=splitVV[end]  ## 결결. 수정대상 폴더 이름

            ############# 수정할 폴더 이름 마련
            df_원소이름=참고원소이름로_원소이름Df(수정대상폴더이름)

            할값들=[색인,막값들]
            se_df_원소이름=원소이름Df_막값수정(df_원소이름,할값들)  ## 결. 수정 된.

            수정할폴더이름=원소이름Df로_참고원소이름(se_df_원소이름)  
            # ## 결결. 수정할 폴더 이름.

            ############# 종. 총이름 들로 만들어 폴더명 수정
            수정대상폴더이름=막장폴더총[ffa-1]*"\\"*수정대상폴더이름
            수정할폴더이름=막장폴더총[ffa-1]*"\\"*수정할폴더이름

            # cd(참고입구총)
            Base.Filesystem.re나me(수정대상폴더이름,수정할폴더이름)  ## 종. 폴더 이름 수정.
        
            막장폴더총=
            폴더총BB_떤번이후_수정_특(막장폴더총,ffa,수정할폴더이름)
            # ## 결. 막장폴더총 변수 수정된 이름으로.
        end
    end
    
    return 막장폴더총  ## 수정된 것 반환
end




################ 신 폴더 생성 필요 유무 판단해서 필요 유시 생성하는 함축
function 신폴더_성(막장폴더총)
    println("function 신폴더_성 시작")

    ################### 필요폴더층번 산출(막장폴더총에서의 번)
    pilyo폴더Cheung번=Vector()

    for ffa in length(막장폴더총):-1:2  ## 4,3,2(=3,2,1층)

        현막장폴더총=막장폴더총[ffa]
        readdirVV=readdir(현막장폴더총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        if length(readdirVV)>=고묶개수

            # ## 결. 필요폴더층번(막장폴더총에서의 번) 붙이기. 
            # # 이 층에 신 폴더 생성 요망.

            if ffa==length(막장폴더총)  ## 최초 회전(맨아래층) 시는 그냥 붙음.

                push!(pilyo폴더Cheung번,ffa)   ## ".cs" 퍄일이 있는 곳은 3+1인 4층임.

            else

                if length(pilyo폴더Cheung번)>=1 && ffa==pilyo폴더Cheung번[end]-1  
                    # ## 하나 더 아래층이 차야지만 붙기 허용
                    push!(pilyo폴더Cheung번,ffa) 
                end
            end
        end
    end

    ################### 필요할 시만 본격 생성
    if length(pilyo폴더Cheung번)>=1  ## 붙었을시만 통과

        ############ 예비 일
        for수=length(pilyo폴더Cheung번)
        현만들폴더=막장폴더총[pilyo폴더Cheung번[end]-1] 

        ############ 본격 붙이기
        for ffa in 1:for수

            현만들폴더*="\\"
            현만들폴더*="Ao신"  ## 붙이기
        end

        println("function 신폴더_성 / mkpath(현만들폴더)=$(현만들폴더)")
        mkpath(현만들폴더)  ## 종. 폴더 만들기.
    end

    println("function 신폴더_성 막")
end




################ df 를 참고로 - insert,append
function df로참고_내1(고테이블이름,df고,색인BB=["ID"])
    # ## 입력: 색인=["ID","EPOCHMS"] 이런식. 퍄일명에는 앞 두 글자가 포함 됨. "EP" 이런식.
 
    ############### 막장 폴더 총이름 마련
    테이블폴더총=테이블폴더성(고테이블이름,고깊이)  
    # ## 깊이 2 손잡이 이나 한번 정하면 그대로 써야 함.
    막장폴더총=테이블폴더로_막장폴더총(테이블폴더총)  ## 결. 막장 폴더 총이름.

    ############### 퍄일 이름 마련
    작값들=Vector()
    막값들=Vector()

    file이름=nothing

    for ffa in 1:length(색인BB)

        현색인=색인BB[ffa]  ## "ID"

        if ffa==1

            file이름=현색인  ## "ID"

        elseif ffa>=2

            file이름*="v"
            file이름*=현색인  ## "vEP"
        end

        ########## 시작 값
        file이름*="v"
        현값=df고[1,현색인]
        file이름*=string(현값)  ## 시작 값 붙이기 

        push!(작값들,현값)  ## 시작 값들 모으기
        
        ########## 막 값
        file이름*="v"
        현값=df고[end,현색인]
        file이름*=string(현값)  ## 막 값 붙이기 

        push!(막값들,현값)  ## 시작 값들 모으기
    end
 
    file이름*=".cs"  ## 확장자 붙이기
    ## "IDv100v200vEPOCHMSv12345v12349.cs"

    ############### 총총이름 마련 후 로고
    총총=막장폴더총[end]*"\\"*file이름

    serialize(총총,df고)
  
    #
    ############### 로고 이후 정보 정리
    ########### 폴더 이름 변경
    막장폴더총=폴더들_이름Je(막장폴더총,색인BB,막값들)

    ########### 신 폴더 생성부 - 필요시만 생성함.
    신폴더_성(막장폴더총)  ## 종. Ao신 폴더 생성.
 
    rra=[1,nrow(df고),0]  ## [최종 성공 유무,성공행 수,실패행 수] - 형식상 반환값.

    return rra
end 




################ df 를 참고로 - insert,append
function df로참고(고형,고테이블이름,df고,색인BB=["ID"])

    #################### 퍄일당 묶음 수 배정
    if 고형=="WON"

        file당묶수=40*6

    elseif 고형=="GAJI"

        file당묶수=40*6

    elseif 고형=="JUB"

        file당묶수=40*6

    elseif 고형=="날"

        file당묶수=40*6

    elseif 고형=="답록"

        file당묶수=1

    elseif 고형=="MIPADO"

        file당묶수=1

    elseif 고형=="입장부"

        file당묶수=40*6

    elseif 고형=="록"
        
        file당묶수=40*6
    end

    #################### 포문 준비
    divremVV=divrem(nrow(df고),file당묶수)

    #################### 본격 포문 로고
    if divremVV[1] !=0

        for ffa in 1:divremVV[1]

            현작번=file당묶수*(ffa-1)+1
            현막번=file당묶수*ffa 

            df고_현=copy(df고[현작번:현막번,:])
            df로참고_내1VV=df로참고_내1(고테이블이름,df고_현,색인BB)
        end
    end

    #################### 마무리 로고
    if divremVV[2] !=0

        ffa=divremVV[1]+1

        현작번=file당묶수*(ffa-1)+1
        현막번=nrow(df고)

        df고_현=copy(df고[현작번:현막번,:])
        df로참고_내1VV=df로참고_내1(고테이블이름,df고_현,색인BB)
    end

    rra=[1,nrow(df고),0]  ## [최종 성공 유무,성공행 수,실패행 수] - 형식상 반환값.

    return rra
end




################ [총이름,총이름 푼 df_원소이름] 이 1행인, 이런 행이 최대 100행인 df 반환
function 참고폴더독로_푼폴더Df(폴더총이름)
  
    나mesVV=["이름_만","총","DF"]
    df_폴더=binDf_성(나mesVV)

    readdirVV=readdir(폴더총이름,join=true)
    readdirVV=참고원소이름_정률(readdirVV,1)

    readdirVV2=readdir(폴더총이름)
    readdirVV2=참고원소이름_정률(readdirVV2,1)

    for ffa in 1:length(readdirVV)

        현Df_원소이름=참고원소이름로_원소이름Df(readdirVV[ffa])
        현BB=[readdirVV2[ffa],readdirVV[ffa],현Df_원소이름]

        push!(df_폴더,현BB)  
        # ## ["이름_만","총","DF"]
    end
    ## df_폴더 는 최대 100행이 됨.

    return df_폴더
end




################ 불러오기 - select 
# 깊이 독립적
function 참고로Df_j1(고테이블이름,색인Jwa값,bdh1,색인,bdh2,색인U값)
    # ## 입력: 참고로Df(테이블이름만,1004,"<","ID","<=",1005) - "<","<="만 됨.

    readdirVV1=readdir(참고입구총)

    if 고테이블이름 ∉ readdirVV1

        return nothing  ## 없을시 nothing 반환

    elseif 고테이블이름 ∈ readdirVV1

        df_찾은_좌=참고로Df_좌찾하강(고테이블이름,색인Jwa값,색인)
        df_찾은_우=참고로Df_우찾하강(고테이블이름,색인,색인U값)
        
        #
        ##################### 읽을 퍄일이름 모음 - 좌끝,중간,우끝 마련
        중간File총이름모음=Vector()  ## 중간을 모으다 보면 맨막 ffa=4 에서 
        # 좌끝,우끝도 모으는 것이니 중간퍄일총이름모음이라 함. 

        ############## 1행 일
        ffa=1
        현번째차_1행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

        if 현번째차_1행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
            
            현정폴더번=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
            
            if length(현정폴더번)>=1

                for ffb in 현정폴더번[1]:현정폴더번[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,현File이름모음)  ## 결. 중간 퍄일이름 모은.
                end
            end
        end
        
        ############## 2행 일
        ffa=2
    
        if 현번째차_1행시==0  ## 1층에서 좌막,우막이 같은 폴더 였을시

            현번째차_2행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_2행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번)>=1

                    for ffb in 현정폴더번[1]:현정폴더번[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end
        
        elseif 현번째차_1행시>=1

            현번째차_2행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번2=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번2)>=1

                for ffb in 현정폴더번2[1]:현정폴더번2[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번2=[i for i in 1:df_찾은_우[ffa,"번째"]-1]

            if length(현정폴더번2)>=1

                for ffb in 현정폴더번2[1]:현정폴더번2[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 3행 일
        ffa=3

        if 현번째차_1행시==0 && 현번째차_2행시==0 
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            현번째차_3행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_3행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번3)>=1
                    
                    for ffb in 현정폴더번3[1]:현정폴더번3[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            현번째차_3행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in 1:df_찾은_우[ffa,"번째"]-1]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 4행 일
        ffa=4

        if 현번째차_1행시==0 && 현번째차_2행시==0 && 현번째차_3행시==0  
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            현번째차_4행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_4행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번3)>=1
                    
                    for ffb in 현정폴더번3[1]:현정폴더번3[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            현번째차_4행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in 1:df_찾은_우[ffa,"번째"]-1]
           
            if length(현정폴더번3)>=1
             
                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)
                 
                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 5행 일 - 막장굴
        ffa=5

        if 현번째차_1행시==0 && 현번째차_2행시==0 && 현번째차_3행시==0 && 현번째차_4행시==0 
            # ## 1층,2층,3층에서 좌막,우막이 같은 폴더 였을시 갈래

            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[df_찾은_좌[ffa,"번째"]:df_찾은_우[ffa,"번째"]]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 끝.

        else  ## 그외 모든 갈래

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[df_찾은_좌[ffa,"번째"]:length(readdirVV)]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 좌끝.

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[1:df_찾은_우[ffa,"번째"]]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 우끝.
        end

        ############# 하나씩만,정정렬
        중간File총이름모음=원소하나S시c만(중간File총이름모음)
        sort!(중간File총이름모음)
        ## 이로서 읽어야할 모든 퍄일총이름을 모았다. 중간File총이름모음 여기에.

        #
        ##################### 읽을 퍄일이름 모음 이후 본격
        df_푼하나=file총이름들로_df하나(중간File총이름모음)  ## 결. df 하나로 합친
        sort!(df_푼하나,색인)

        ################# 끊어 읽을 시작번,막번 찾기
        ############# 시작번
        찾은작번=1

        for ffa in 1:nrow(df_푼하나)

            if bdh1=="<"

                if 색인Jwa값<df_푼하나[ffa,색인]

                    찾은작번=ffa
                    break
                end

            elseif bdh1=="<="

                if 색인Jwa값<=df_푼하나[ffa,색인]

                    찾은작번=ffa
                    break
                end
            end
        end

        ############# 막번
        찾은막번=nrow(df_푼하나)

        for ffa in nrow(df_푼하나):-1:1

            if bdh2=="<"

                if df_푼하나[ffa,색인]<색인U값

                    찾은막번=ffa
                    break
                end

            elseif bdh2=="<="

                if df_푼하나[ffa,색인]<=색인U값

                    찾은막번=ffa
                    break
                end
            end
        end

        ################# 종. 끊어서 반환
        df_rra=copy(df_푼하나[찾은작번:찾은막번,:])  ## 종. 끊기.
    
        return df_rra
    end
end




################ 불러오기 - select 
# 깊이 독립적
# 2022년 9월 5일 오후 5시41분- 수정 시작한.
function 참고로Df(고테이블이름,색인Jwa값,bdh1,색인,bdh2,색인U값)
    # ## 입력: 참고로Df(테이블이름만,1004,"<","ID","<=",1005) - "<","<="만 됨.

    readdirVV1=readdir(참고입구총)

    if 고테이블이름 ∉ readdirVV1

        return nothing  ## 없을시 nothing 반환

    elseif 고테이블이름 ∈ readdirVV1

        df_찾은_좌=참고로Df_좌찾하강(고테이블이름,색인Jwa값,색인)
        df_찾은_우=참고로Df_우찾하강(고테이블이름,색인,색인U값)
        
        #
        ##################### 읽을 퍄일이름 모음 - 좌끝,중간,우끝 마련
        중간File총이름모음=Vector()  ## 중간을 모으다 보면 맨막 ffa=4 에서 
        # 좌끝,우끝도 모으는 것이니 중간퍄일총이름모음이라 함. 

        ############## 1행 일
        ffa=1
        현번째차_1행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

        if 현번째차_1행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
            
            현정폴더번=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
            
            if length(현정폴더번)>=1

                for ffb in 현정폴더번[1]:현정폴더번[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,현File이름모음)  ## 결. 중간 퍄일이름 모은.
                end
            end
        end
        
        ############## 2행 일
        ffa=2
    
        if 현번째차_1행시==0  ## 1층에서 좌막,우막이 같은 폴더 였을시

            현번째차_2행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_2행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번)>=1

                    for ffb in 현정폴더번[1]:현정폴더번[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end
        
        elseif 현번째차_1행시>=1

            현번째차_2행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번2=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번2)>=1

                for ffb in 현정폴더번2[1]:현정폴더번2[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번2=[i for i in 1:df_찾은_우[ffa,"번째"]-1]

            if length(현정폴더번2)>=1

                for ffb in 현정폴더번2[1]:현정폴더번2[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 3행 일
        ffa=3

        if 현번째차_1행시==0 && 현번째차_2행시==0 
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            현번째차_3행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_3행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번3)>=1
                    
                    for ffb in 현정폴더번3[1]:현정폴더번3[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            현번째차_3행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in 1:df_찾은_우[ffa,"번째"]-1]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 4행 일
        ffa=4

        if 현번째차_1행시==0 && 현번째차_2행시==0 && 현번째차_3행시==0  
            # ## 1층,2층에서 좌막,우막이 같은 폴더 였을시 갈래

            현번째차_4행시=df_찾은_우[ffa,"번째"]-df_찾은_좌[ffa,"번째"]

            if 현번째차_4행시>=2  ## 소수 갈래 - 중간이 있을시 # 1,2,3
                
                현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:df_찾은_우[ffa,"번째"]-1]
                
                if length(현정폴더번3)>=1
                    
                    for ffb in 현정폴더번3[1]:현정폴더번3[end]

                        현File이름모음=
                        참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                        append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                    end
                end
            end

        else  ## 그외 모든 갈래

            현번째차_4행시=-1004.1004  ## 껍데기 대입

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in df_찾은_좌[ffa,"번째"]+1:length(readdirVV)]

            if length(현정폴더번3)>=1

                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_좌[ffa,"현총"],ffb)

                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현정폴더번3=[i for i in 1:df_찾은_우[ffa,"번째"]-1]
           
            if length(현정폴더번3)>=1
             
                for ffb in 현정폴더번3[1]:현정폴더번3[end]

                    현File이름모음=
                    참고로Df_총Wa폴더번로_막장File이름모음(ffa,df_찾은_우[ffa,"현총"],ffb)
                 
                    append!(중간File총이름모음,copy(현File이름모음))  ## 결. 중간 퍄일이름 모은.
                end
            end
        end

        ############## 5행 일 - 막장굴
        ffa=5

        if 현번째차_1행시==0 && 현번째차_2행시==0 && 현번째차_3행시==0 && 현번째차_4행시==0 
            # ## 1층,2층,3층에서 좌막,우막이 같은 폴더 였을시 갈래

            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[df_찾은_좌[ffa,"번째"]:df_찾은_우[ffa,"번째"]]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 끝.

        else  ## 그외 모든 갈래

            ############# 좌막
            현총=df_찾은_좌[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[df_찾은_좌[ffa,"번째"]:length(readdirVV)]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 좌끝.

            ############# 우막
            현총=df_찾은_우[ffa-1,"현총"]
            readdirVV=readdir(현총,join=true)
            readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
            readdirVV=참고원소이름_정률(readdirVV,1)

            현File이름모음=readdirVV[1:df_찾은_우[ffa,"번째"]]

            append!(중간File총이름모음,copy(현File이름모음))  ## 종. 퍄일 모음 우끝.
        end

        ############# 하나씩만,정정렬
        중간File총이름모음=원소하나S시c만(중간File총이름모음)
        sort!(중간File총이름모음)
        ## 이로서 읽어야할 모든 퍄일총이름을 모았다. 중간File총이름모음 여기에.

        #
        ##################### 읽을 퍄일이름 모음 이후 본격
        df_푼하나=file총이름들로_df하나(중간File총이름모음)  ## 결. df 하나로 합친
        sort!(df_푼하나,색인)

        ################# 끊어 읽을 시작번,막번 찾기
        ############# 시작번
        찾은작번=1

        for ffa in 1:nrow(df_푼하나)

            if bdh1=="<"

                if 색인Jwa값<df_푼하나[ffa,색인]

                    찾은작번=ffa
                    break
                end

            elseif bdh1=="<="

                if 색인Jwa값<=df_푼하나[ffa,색인]

                    찾은작번=ffa
                    break
                end
            end
        end

        ############# 막번
        찾은막번=nrow(df_푼하나)

        for ffa in nrow(df_푼하나):-1:1

            if bdh2=="<"

                if df_푼하나[ffa,색인]<색인U값

                    찾은막번=ffa
                    break
                end

            elseif bdh2=="<="

                if df_푼하나[ffa,색인]<=색인U값

                    찾은막번=ffa
                    break
                end
            end
        end

        ################# 종. 끊어서 반환
        df_rra=copy(df_푼하나[찾은작번:찾은막번,:])  ## 종. 끊기.
    
        return df_rra
    end
end




################ 불러오기 중 좁히기 전용
function 참고로Df_우찾하강(고테이블이름,색인,색인U값)

    나meVV=["현총","번째","이름_만"]
    df_찾기=binDf_성(나meVV)  ## 결. df 최초 마련.

    현폴더총이름=참고입구총*"\\"*고테이블이름  ## "C:\\참고\\테이블" 총이름

    깊이_cca=0

    while true

        현Df_폴더=참고폴더독로_푼폴더Df(현폴더총이름)  ## 최대 100행인

        ############### 보정
        if 현Df_폴더[1,"이름_만"]=="Ao신"

            현Df_폴더=copy(현Df_폴더[setdi변수(1:end,1),:])
        end

        ############### 우측 막값 찾기
        찾은값위치=nothing
        다찾은=0  ## 다 찾은 0

        for ffa in nrow(현Df_폴더):-1:1

            현Df_원소이름=현Df_폴더[ffa,"DF"]  ## ["색인","작값","막값"]

            for ffb in 1:nrow(현Df_원소이름)

                현색인=현Df_원소이름[ffb,"색인"]  ## 단순히 색인이 같을 시를 위한

                if 현색인==색인  ## 단순히 색인이 같을 시

                    ########## 결. 찾아서 위치 기록
                    if 색인U값<=현Df_원소이름[ffb,"막값"]

                        찾은값위치=ffa  ## 결. 찾은 막값 위치 ffa
                      
                    elseif 현Df_원소이름[ffb,"막값"]<색인U값

                        if ffa==nrow(현Df_폴더)  

                            찾은값위치=ffa  ## 색인U값 먼산 일시 처리
                        end

                        다찾은=1
                        break
                    end
                end
            end

            if 다찾은==1
                break
            end
        end

        ############### 찾은 이후 정보 정리
        현1행=[현Df_폴더[찾은값위치,"총"],찾은값위치,현Df_폴더[찾은값위치,"이름_만"]]  
        # ## 결. df 에 붙일 1행 - 최초시 "C:\\참고\\테이블\\IDv100v110" - 1단계 
        # # global 고깊이=3 이면 4단계까지 붙고, 4단계에 .cs 퍄일명이 있다.
        push!(df_찾기,현1행)  ## 결. 붙이기.

        ########### 브레이크 부
        깊이_cca+=1

        if 깊이_cca>=고깊이+1

            break
        end

        ########### 회전하는 현폴더총이름 갱신
        현폴더총이름*="\\"
        현폴더총이름*=현Df_폴더[찾은값위치,"이름_만"]
    end

    return df_찾기  ## ["현총","번째","이름_만"] 
    # # df_찾기 막행 이하를 수입해야 함.
end




################ 불러오기 중 좁히기 전용
function 참고로Df_좌찾하강(고테이블이름,색인Jwa값,색인)

    나meVV=["현총","번째","이름_만"]
    df_찾기=binDf_성(나meVV)  ## 결. df 최초 마련.

    현폴더총이름=참고입구총*"\\"*고테이블이름  ## "C:\\참고\\테이블" 총이름

    깊이_cca=0

    while true

        현Df_폴더=참고폴더독로_푼폴더Df(현폴더총이름)  ## 최대 100행인

        ############### 보정
        if 현Df_폴더[1,"이름_만"]=="Ao신"

            현Df_폴더=copy(현Df_폴더[setdi변수(1:end,1),:])
        end

        ############### 우측 막값 찾기
        찾은값위치=nothing
        다찾은=0  ## 다 찾은 0

        for ffa in 1:nrow(현Df_폴더)

            현Df_원소이름=현Df_폴더[ffa,"DF"]  ## ["색인","작값","막값"]

            for ffb in 1:nrow(현Df_원소이름)

                현색인=현Df_원소이름[ffb,"색인"]  ## 단순히 색인이 같을 시를 위한

                if 현색인==색인  ## 단순히 색인이 같을 시

                    ########## 결. 찾아서 위치 기록
                    if 현Df_원소이름[ffb,"작값"]<=색인Jwa값

                        찾은값위치=ffa  ## 결. 찾은 막값 위치 ffa
                    
                    elseif 색인Jwa값<현Df_원소이름[ffb,"작값"]
                     
                        if ffa==1 

                            찾은값위치=ffa  ## 색인Jwa값 먼산 일시 처리
                        end
                     
                        다찾은=1
                        break
                    end
                end
            end
       
            if 다찾은==1

                break
            end
        end

        ############### 찾은 이후 정보 정리
        현1행=[현Df_폴더[찾은값위치,"총"],찾은값위치,현Df_폴더[찾은값위치,"이름_만"]]  
        # ## 결. df 에 붙일 1행
        push!(df_찾기,현1행)  ## 결. 붙이기.

        ########### 브레이크 부
        깊이_cca+=1

        if 깊이_cca>=고깊이+1

            break
        end

        ########### 회전하는 현폴더총이름 갱신
        현폴더총이름*="\\"
        현폴더총이름*=현Df_폴더[찾은값위치,"이름_만"]
    end

    return df_찾기  ## ["현총","번째","이름_만"] 
    # # df_찾기 막행 이상을 수입해야 함.
end




################ 폴더번이 본폴더가 되고 그 폴더 이하 막장의 jls 퍄일 이름을 읽어 모으는 것
# - global 고깊이=3 층만 됨. 참고전에서 층을 바꾸면 이 함축이 전부 수정돼야 함.
# 2. 고깊이=4 층으로 수정함.
# 깊이 독립적
function 참고로Df_총Wa폴더번로_막장File이름모음(je총현다n,je총,bon폴더번)
    # ## 입력: 형제폴더현재단- 1이면 1단 / 형제폴더의 총이름- 참고로Df_좌찾하강 의 행 현총 
    # / 형제폴더가 있는 곳을 정정렬시 본 폴더의 번째
    # # je총현다n 막장부터 1층으로 올라오며 짰다. 그래서 1층 쪽 변수들이 퍄일명에 3이 붙음.

    file이름모음=Vector()

    if je총현다n==1

        ############# 1층 일
        sang_총이름4=총이름로_sangSeung(je총,1)  ## 테이블 층
        readdirVV4=readdir(sang_총이름4,join=true)  ## 2층 220개
        readdirVV4=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV4,"Ao신")
        readdirVV4=참고원소이름_정률(readdirVV4,1)

        readdirVV_나4=readdir(readdirVV4[bon폴더번],join=true)  ## 3층 100개
        readdirVV_나4=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나4,"Ao신")
        readdirVV_나4=참고원소이름_정률(readdirVV_나4,1)

        for ffc in 1:length(readdirVV_나4)

            ############# 2층 일
            현폴더4=readdirVV_나4[ffb]

            readdirVV_나3=readdir(현폴더4,join=true)  ## 4층 100개
            readdirVV_나3=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나3,"Ao신")
            readdirVV_나3=참고원소이름_정률(readdirVV_나3,1)

            for ffb in 1:length(readdirVV_나3)

                현폴더3=readdirVV_나3[ffb]

                readdirVV_나2=readdir(현폴더3,join=true)  ## 4층 100개
                readdirVV_나2=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나2,"Ao신")
                readdirVV_나2=참고원소이름_정률(readdirVV_나2,1)

                for ffa in 1:length(readdirVV_나2)

                    현폴더2=readdirVV_나2[ffa]
        
                    ####### 4층 일
                    readdirVV_나=readdir(현폴더2,join=true)
                    readdirVV_나=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나,"Ao신")
                    readdirVV_나=참고원소이름_정률(readdirVV_나,1)
                    append!(file이름모음,readdirVV_나)  ## 결결. 붙이기.
                end
            end
        end

    elseif je총현다n==2

        ############# 2층 일
        sang_총이름3=총이름로_sangSeung(je총,1)  ## 테이블 층
        readdirVV3=readdir(sang_총이름3,join=true)  ## 2층 100개
        readdirVV3=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV3,"Ao신")
        readdirVV3=참고원소이름_정률(readdirVV3,1)

        readdirVV_나3=readdir(readdirVV3[bon폴더번],join=true)  ## 3층 100개
        readdirVV_나3=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나3,"Ao신")
        readdirVV_나3=참고원소이름_정률(readdirVV_나3,1)

        for ffb in 1:length(readdirVV_나3)

            현폴더3=readdirVV_나3[ffb]

            readdirVV_나2=readdir(현폴더3,join=true)  ## 4층 100개
            readdirVV_나2=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나2,"Ao신")
            readdirVV_나2=참고원소이름_정률(readdirVV_나2,1)

            for ffa in 1:length(readdirVV_나2)

                현폴더2=readdirVV_나2[ffa]
    
                ####### 4층 일
                readdirVV_나=readdir(현폴더2,join=true)
                readdirVV_나=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나,"Ao신")
                readdirVV_나=참고원소이름_정률(readdirVV_나,1)
                append!(file이름모음,readdirVV_나)  ## 결결. 붙이기.
            end
        end

    elseif je총현다n==3

        ########## 3층 일
        sang_총이름2=총이름로_sangSeung(je총,1)  ## 2층
        readdirVV2=readdir(sang_총이름2,join=true)  ## 3층 100개
        readdirVV2=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV2,"Ao신")
        readdirVV2=참고원소이름_정률(readdirVV2,1)

        readdirVV_나2=readdir(readdirVV2[bon폴더번],join=true)  ## 4층 100개
        readdirVV_나2=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나2,"Ao신")
        readdirVV_나2=참고원소이름_정률(readdirVV_나2,1)

        for ffa in 1:length(readdirVV_나2)

            현폴더2=readdirVV_나2[ffa]

            ####### 4층 일
            readdirVV_나=readdir(현폴더2,join=true)
            readdirVV_나=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나,"Ao신")
            readdirVV_나=참고원소이름_정률(readdirVV_나,1)
            append!(file이름모음,readdirVV_나)  ## 결결. 붙이기.
        end

    elseif je총현다n==4  ## 마지막 4층 폴더시

        ####### 4층 일
        sang_총이름1=총이름로_sangSeung(je총,1)
        readdirVV=readdir(sang_총이름1,join=true)
        readdirVV=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV,"Ao신")
        readdirVV=참고원소이름_정률(readdirVV,1)

        readdirVV_나=readdir(readdirVV[bon폴더번],join=true)
        readdirVV_나=stringBB_원소중_떤String_po하m_원소_jeguBB(readdirVV_나,"Ao신")
        readdirVV_나=참고원소이름_정률(readdirVV_나,1)
        append!(file이름모음,readdirVV_나)  ## 결결. 붙이기.
    end

    return file이름모음
end




################ jls 퍄일 총 이름들 입력받으면 푼 df 하나 반환
function file총이름들로_df하나(file총이름모음)

    ffa=1
 
    df_푼하나=deserialize(file총이름모음[ffa])
    # ## 결. df 하나 최초 마련

    for ffa in 2:length(file총이름모음)

        현푼Df=deserialize(file총이름모음[ffa])

        append!(df_푼하나,현푼Df)  ## 결. df 하나에 붙이기.
    end

    return df_푼하나
end




################ 특수목적 막장폴더총 이름을 순차적으로 변경하기 위한 것
function 폴더총BB_떤번이후_수정_특(폴더총BB,떤번,수정할폴더이름)

    수정할폴더이름_splitVV=split(수정할폴더이름,"\\")

    for ffa in 떤번:length(폴더총BB)

        현폴더총=폴더총BB[ffa]
        현폴더총_spitVV=split(현폴더총,"\\")

        for ffb in 1:length(수정할폴더이름_splitVV)

            if 현폴더총_spitVV[ffb] !=수정할폴더이름_splitVV[ffb]

                현폴더총_spitVV[ffb]=수정할폴더이름_splitVV[ffb]
                # ## 결. 수정.
            end
        end

        se_현폴더총=stringBB_gyung로하b(현폴더총_spitVV)
        폴더총BB[ffa]=se_현폴더총  ## 수정 배치
    end

    return 폴더총BB
end




################ "v" 로 나눠져 있는 참고원소이름 을 정정렬 또는 역정렬 하는 것.
# 참고원소이름_정률 본체
function 참고원소이름_정률(원소이름BB,정나Yuc)
    # ## 정정렬이나 역정렬- 1 정정렬, 2역정렬

    if length(원소이름BB)==0

        return Any[]

    else

        ################# 길이순으로 1차 정렬
        원소기li들=Vector()

        for ffa in 1:length(원소이름BB)

            현원소기li=length(원소이름BB[ffa])
            push!(원소기li들,현원소기li)
        end

        df_an내=다taFrame(기LI=원소기li들,IB=원소이름BB)

        if 정나Yuc==1

            sort!(df_an내,"기LI")

        elseif 정나Yuc==2

            sort!(df_an내,"기LI",rev=true)
        end

        원소이름BB=df_an내[!,"IB"]

        ################# "C:\\ORI" 이럴시 분절수로 2차 정렬
        vv3차Hu=1  ## 3차 정렬 허가 1로 초기화

        ffa=1
        splitVV=split(원소이름BB[end],"\\")

        if length(splitVV)>=2

            번jul수=Vector()

            for ffa in 1:length(원소이름BB)

                splitVV=split(원소이름BB[ffa],"\\")
                현번jul수=length(splitVV)

                push!(번jul수,현번jul수)
            end

            if 번jul수[1] !=번jul수[end]  ## 분절수가 다를시

                vv3차Hu=0  ## 3차 정렬 허가 0 처리
            end

            df_an내=다taFrame(수=번jul수,IB=원소이름BB)

            if 정나Yuc==1

                sort!(df_an내,"수")

            elseif 정나Yuc==2

                sort!(df_an내,"수",rev=true)
            end

            원소이름BB=df_an내[!,"IB"]
        end

        #
        ################# 참고원소이름 규칙에 따라 3차 정렬
        if vv3차Hu==1  ## 허가 있을 시만 통과

            sanHu=0

            ############### 마지막 검사 
            # "C:\\참고\\AD고_2_JJOIL_TS_SL01_WONCHEON\\WON_IDv1v1599763\\WON_IDv1v1599763\\Ao신\\Ao신"
            splitVV=split(원소이름BB[end],"\\")
            splitVV2=split(splitVV[end],"v")

            if length(splitVV2)>=2

                sanHu=1  ## 참고원소이름 규칙을 따르면 산출 허가
            end

            ############### 산출
            if sanHu==1  ## 허가시만

                an내값들=Vector()

                for ffa in 1:length(원소이름BB)

                    splitVV=split(원소이름BB[ffa],"v")

                    findlastVV1=findlast("Ao신",splitVV[end])

                    if findlastVV1==nothing

                        findlastVV=findlast(".cs",splitVV[end])        

                        if findlastVV==nothing

                            현An내값=parse(Float64,splitVV[end])

                        else

                            splitVV2=split(splitVV[end],".")
                            현An내값=parse(Float64,splitVV2[1])
                        end

                        push!(an내값들,현An내값)  ## "ID","1001" 이런식으로 돼 있는데서 
                        # "1001" 숫자로 만들어 붙임.

                    else  ## "Ao신" 있을 경우 

                        현An내값=-Inf  ## 맨 처음으로 배치
                        push!(an내값들,현An내값) 
                    end
                end

                df_an내=다taFrame(AN내값=an내값들,IB=원소이름BB)

                if 정나Yuc==1

                    sort!(df_an내,"AN내값")

                elseif 정나Yuc==2

                    sort!(df_an내,"AN내값",rev=true)
                end

                정률Doin_원소이름BB=copy(df_an내[:,"IB"])  ## 종. 3차까지 정렬된

            else

                정률Doin_원소이름BB=copy(원소이름BB)
            end

        else

            정률Doin_원소이름BB=copy(원소이름BB)
        end

        return 정률Doin_원소이름BB
    end
end




################ 지정한 색인의 저장된 최대값 - select Max()
function 색인De값(고테이블이름::String,색인::String)

    readdirVV=readdir(참고입구총)

    if 고테이블이름 ∈ readdirVV  ## 테이블이 있으면 통과

        고테이블이름총=참고입구총*"\\"*고테이블이름

        readdirVV=readdir(고테이블이름총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        ############# 본격 - 맨 마지막 폴더 읽어서 df_원소이름 풀어서.
        if readdirVV[end] !="Ao신"

            현_readdirVV_end=readdirVV[end]

        else

            현_readdirVV_end=readdirVV[end-1]
        end

        df_원소이름=참고원소이름로_원소이름Df(현_readdirVV_end)

        찾은De값=0  ## 0으로 초기화

        for ffa in 1:nrow(df_원소이름)

            if df_원소이름[ffa,"색인"]==색인

                찾은De값=df_원소이름[ffa,"막값"]
                break
            end
        end

        return 찾은De값

    else  ## 테이블 자체가 없으면 0 반환
        
        return 0
    end
end




################
function Ao신_폴더_sacje(테이블폴더총)

    현총=테이블폴더총

    for ffa in 1:고깊이

        readdirVV=readdir(현총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        if "Ao신" ∈ readdirVV

            rmFile총=현총*"\\"*"Ao신"
            rm(rmFile총,recur시ve=true)  ## 결. 삭제. 하위 폴더까지 다 삭제함. # 총 자체 폴더 삭제함.

            break

        else

            현총*="\\"
            현총*=readdirVV[end]
        end
    end
end




################ 막행부터 앞으로 가며 삭제 
# - 기술: 막행부터 앞으로 가며 삭제함. 퍄일 1개 삭제후 폴더명 정비를 반복하다 
# 유지최대값 만나면 종료함. 유지최대값 있는 퍄일 까지 삭제후 폴더명 정비후 
# 유지최대값 만큼 1~2행 정도 쓰기하고 마무리.
# 사용 유
function 막행부tu_sacje(고형,고테이블이름::String,색인::String,ujiDe값)
    # ## 색인의 유지최대값 초과하는 행들은 삭제됨.
    println("function 막행부tu_sacje 시작")

    색인De값VV=색인De값(고테이블이름,색인)

    if ujiDe값<색인De값VV  ## 삭제 조건이 맞을 시만 통과

        테이블폴더총=참고입구총*"\\"*고테이블이름  ## "C:\\참고\\테이블" 총이름

        Ao신_폴더_sacje(테이블폴더총)
   
        ######################## Ao신 폴더 삭제 이후
        whileheureum=1
        wwa=0

        while true

            wwa+=1
            println("function 막행부tu_sacje 와일 wwa=$wwa 회")

            ##################
            막장폴더총_jaryo만=테이블폴더로_막장폴더총(테이블폴더총)
            # ## 결. 자료만 막장 폴더 총이름.

            ##################
            막장File들=readdir(막장폴더총_jaryo만[end])
            막장File들=참고원소이름_정률(막장File들,1)

            현막File=막장File들[end]  ## 결. 대상인 막장의 마지막 퍄일.
            현막File총=막장폴더총_jaryo만[end]*"\\"*현막File  ## 결.
            현막File_df_원소이름=참고원소이름로_원소이름Df(현막File)
            # ## ["색인","작값","막값"]

            현색인BB=현막File_df_원소이름[:,"색인"]

            ################## 막장 마지막 퍄일이 삭제 필요한지 흐름 판단부
            현막Fileheureum=0

            for ffa in 1:nrow(현막File_df_원소이름)

                if 현막File_df_원소이름[ffa,"색인"]==색인

                    if ujiDe값<현막File_df_원소이름[ffa,"작값"]

                        현막Fileheureum=10  ## 삭제만 필요 10 부여

                    elseif 현막File_df_원소이름[ffa,"작값"]<=ujiDe값<=현막File_df_원소이름[ffa,"막값"]

                        현막Fileheureum=101  ## 삭제후 일부행을 다시 쓰기 필요 101 부여

                    elseif 현막File_df_원소이름[ffa,"막값"]<ujiDe값  ## 무일 혹시나 갈래 - 삭제 불필요

                        ################## 신 폴더 생성부 - 필요시만 생성함.
                        막장폴더총_jaryo만=테이블폴더로_막장폴더총(테이블폴더총)
                        신폴더_성(막장폴더총_jaryo만)  ## 종. Ao신 폴더 생성.

                        whileheureum=-1004
                        break
                    end
                end
            end

            ################## 삭제할 퍄일이 그 폴더의 마지막 퍄일인지
            현폴더막File=0  ## 일상 0 부여

            if length(막장File들)==1

                현폴더막File=1  ## 마지막 퍄일만 있는 경우 1 부여
            end

            #
            ################## 흐름 판단이후 본격 - 삭제 후 폴더 이름 쭉 수정
            if 현막Fileheureum==10  ## 삭제만 할 갈래

                ################ 삭제
                if 현폴더막File==0  ## 일상 갈래

                    ################ 새로 쓸 폴더 이름 쭉 마련
                    현ssjul대상=막장File들[end-1] 
                    현ssjul대상_df_원소이름=참고원소이름로_원소이름Df(현ssjul대상)

                    ################ 막값들 모으기
                    막값들=Vector()

                    for ffa in 1:nrow(현ssjul대상_df_원소이름)

                        현값=현ssjul대상_df_원소이름[ffa,"막값"]
                        push!(막값들,현값)  ## 막값들
                    end

                    ################ 새로 쓸 이름 마련 이후 삭제할 것 삭제
                    rm(현막File총)  ## 종. 삭제.

                    ################ 종결. 폴더 이름 쭉 수정하기
                    폴더들_이름Je(막장폴더총_jaryo만,현색인BB,막값들)

                elseif 현폴더막File==1  ## 제2 갈래

                    rm(현막File총)  ## 종. 삭제.

                    ################ 폴더 삭제
                    for ffa in length(막장폴더총_jaryo만):-1:2

                        현독폴더=막장폴더총_jaryo만[ffa]
                        readdirVV2=readdir(현독폴더)

                        if length(readdirVV2)==0

                            rm(현독폴더)
                            # ## 종. 마지막 퍄일 있던 폴더 삭제.
                        end
                    end

                    ################
                    막장폴더총_jaryo만=테이블폴더로_막장폴더총(테이블폴더총)

                    현ssjul대상_df_원소이름=참고원소이름로_원소이름Df(막장폴더총_jaryo만[end])

                    ################ 막값들 모으기
                    막값들=Vector()

                    for ffa in 1:nrow(현ssjul대상_df_원소이름)

                        현값=현ssjul대상_df_원소이름[ffa,"막값"]
                        push!(막값들,현값)  ## 막값들
                    end

                    ################ 종결. 폴더 이름 쭉 수정하기
                    폴더들_이름Je(막장폴더총_jaryo만,현색인BB,막값들)
                end

            elseif 현막Fileheureum==101  ## 삭제 후 써야할 갈래

                ################ 삭제 후 쓸 df 마련 
                현푼Df=deserialize(현막File총)

                찾은행번=1

                for ffa in 1:nrow(현푼Df)

                    if 현푼Df[ffa,색인]<=ujiDe값

                        찾은행번=ffa 

                    else

                        break
                    end
                end

                sacj이후ssjulDf=현푼Df[1:찾은행번,:]  ## 결. 쓸 df 마련. 

                ################ 삭제
                if 현폴더막File==0  ## 일상 갈래

                    ################ 새로 쓸 폴더 이름 쭉 마련
                    현ssjul대상=막장File들[end-1] 
                    현ssjul대상_df_원소이름=참고원소이름로_원소이름Df(현ssjul대상)

                    ################ 막값들 모으기
                    막값들=Vector()

                    for ffa in 1:nrow(현ssjul대상_df_원소이름)

                        현값=현ssjul대상_df_원소이름[ffa,"막값"]
                        push!(막값들,현값)  ## 막값들
                    end

                    ################ 새로 쓸 이름 마련 이후 삭제할 것 삭제
                    rm(현막File총)  ## 종. 삭제.

                    ################ 종결. 폴더 이름 쭉 수정하기
                    폴더들_이름Je(막장폴더총_jaryo만,현색인BB,막값들)

                elseif 현폴더막File==1  ## 제2 갈래

                    rm(현막File총)  ## 종. 삭제.

                    ################ 폴더 삭제
                    for ffa in length(막장폴더총_jaryo만):-1:2

                        현독폴더=막장폴더총_jaryo만[ffa]
                        readdirVV2=readdir(현독폴더)

                        if length(readdirVV2)==0

                            rm(현독폴더)
                            # ## 종. 마지막 퍄일 있던 폴더 삭제.
                        end
                    end

                    ################
                    막장폴더총_jaryo만=테이블폴더로_막장폴더총(테이블폴더총)

                    현ssjul대상_df_원소이름=참고원소이름로_원소이름Df(막장폴더총_jaryo만[end])

                    ################ 막값들 모으기
                    막값들=Vector()

                    for ffa in 1:nrow(현ssjul대상_df_원소이름)

                        현값=현ssjul대상_df_원소이름[ffa,"막값"]
                        push!(막값들,현값)  ## 막값들
                    end

                    ################ 종결. 폴더 이름 쭉 수정하기
                    폴더들_이름Je(막장폴더총_jaryo만,현색인BB,막값들)
                end

                ################## 신 폴더 생성부 - 필요시만 생성함.
                막장폴더총_jaryo만=테이블폴더로_막장폴더총(테이블폴더총)
                신폴더_성(막장폴더총_jaryo만)  ## 종. Ao신 폴더 생성.

                ################ 삭제 후 다시 쓰기
                df로참고(고형,고테이블이름,sacj이후ssjulDf,현색인BB)  ## 종결. 다시 쓰기.

                whileheureum=-1004  ## 와일 종료 흐름 부여
            end

            if whileheureum==-1004

                break  ## 와일 브레이크
            end
        end
    end

    println("function 막행부tu_sacje 끝")
end




################
# 유지대값 날고 막 아이디를 입력하면 그 이하까지만 남기고 전 세계 삭제하는
# 날고막Id로_segeSacje(1,3525-2)
function 날고막Id로_segeSacje(slIn,uji날고막Id)

    if slIn==1

        현Won고이름=CHg01_sl_woncheon고이름
        현Gaji25고이름=CHg01_sl_gaji25고이름
        현Gaji50고이름=CHg01_sl_gaji50고이름
        현Gaji100고이름=CHg01_sl_gaji100고이름
        현Jub고이름=CHg01_sl_jub하b고이름
        현날고이름=CHg01_sl_날고이름

    else slIn==2

        현Won고이름=CHg01_in_woncheon고이름
        현Gaji25고이름=CHg01_in_gaji25고이름
        현Gaji50고이름=CHg01_in_gaji50고이름
        현Gaji100고이름=CHg01_in_gaji100고이름
        현Jub고이름=CHg01_in_jub하b고이름
        현날고이름=CHg01_in_날고이름
    end

    ###################### 유지대값의 원천고 아이디 마련
    ujiDe날고=참고로Df(현날고이름,uji날고막Id,"<=","날_ID","<=",uji날고막Id)
    # ## 유지대값의 날고 읽은 

    ujiDeWon고=
    참고로Df(현Won고이름,ujiDe날고[1,"시_WON_ID"],"<=","WON_ID","<=",ujiDe날고[1,"막시_WON_ID"])
    # ## 유지대값의 원천고 

    ujiDeWonId=ujiDeWon고[end,"WON_ID"]  ## 결. 유지대값의 원천 아이디 

    #
    ################################# 삭제 본격
    ###################### 원천고 삭제
    현Sacje대상고=현Won고이름
 
    고형="WON"
    색인="WON_ID"
    ujiDe값=ujiDeWonId

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)

    ###################### 가지고 삭제
    현Sacje대상고=현Gaji25고이름
    현Secje대상고_독Df=참고로Df(현Sacje대상고,ujiDeWonId-10000,"<","시_WON_ID","<=",ujiDeWonId)

    고형="GAJI"
    색인="GAJI25_ID"
    ujiDe값=현Secje대상고_독Df[end,색인]

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)

    ###################### 
    현Sacje대상고=현Gaji50고이름
    현Secje대상고_독Df=참고로Df(현Sacje대상고,ujiDeWonId-10000,"<","시_WON_ID","<=",ujiDeWonId)

    고형="GAJI"
    색인="GAJI50_ID"
    ujiDe값=현Secje대상고_독Df[end,색인]

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)

    ###################### 
    현Sacje대상고=현Gaji100고이름
    현Secje대상고_독Df=참고로Df(현Sacje대상고,ujiDeWonId-10000,"<","시_WON_ID","<=",ujiDeWonId)

    고형="GAJI"
    색인="GAJI100_ID"
    ujiDe값=현Secje대상고_독Df[end,색인]

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)

    ###################### 접합고
    현Sacje대상고=현Jub고이름
    현Secje대상고_독Df=참고로Df(현Sacje대상고,ujiDeWonId-10000,"<","시_WON_ID","<=",ujiDeWonId)

    고형="JUB"
    색인="JUB_ID"
    ujiDe값=현Secje대상고_독Df[end,색인]

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)

    ###################### 
    현Sacje대상고=현날고이름
    현Secje대상고_독Df=참고로Df(현Sacje대상고,ujiDeWonId-100000,"<","시_WON_ID","<=",ujiDeWonId)

    고형="날"
    색인="날_ID"
    ujiDe값=현Secje대상고_독Df[end,색인]

    막행부tu_sacje(고형,현Sacje대상고,색인,ujiDe값)
end




################
# 맨 앞 조작만으로 epochms 로 원천고 아이디 찾기 변용 가능.
# dt로참고WoncheonId_dict(현Dt)
function dt로참고WoncheonId_dict(ibDt,slIn=1)
    # ## 실인- 실제원천고냐 인조원천고냐

    ibDt_epochms=다tes.다tetime2epochms(ibDt)  
    # ## 이 함축을 epochms 입력으로 하고 싶으면 여기 조작부터가 시작

    ############################# 준비
    if slIn==1

        현Woncheon고이름=CHg01_sl_woncheon고이름

    elseif slIn==2

        현Woncheon고이름=CHg01_in_woncheon고이름
    end

    woncheon_id수=색인De값(현Woncheon고이름,"WON_ID")

    ################## 와일당 찾을 작아이디 막아이디 부여
    현Won고찾작Id=1
    현Won고찾막Id=woncheon_id수

    ############################# 와일 본격
    찾은Won고Id=nothing
    찾은Won고Epochms=nothing
    찾heureum=0

    while 찾heureum==0

        ################## 독중아이디 산출
        현Won고독정Id=(현Won고찾작Id+현Won고찾막Id)*0.5
        현Won고독정Id=Int(로und(현Won고독정Id))

        ################## 3지점 작,중,막 아이디 epochms 읽기
        현Won고찾작Id_독행=참고로Df(현Woncheon고이름,현Won고찾작Id,"<=","WON_ID","<=",현Won고찾작Id)
        현Won고독정Id_독행=참고로Df(현Woncheon고이름,현Won고독정Id,"<=","WON_ID","<=",현Won고독정Id)
        현Won고찾막Id_독행=참고로Df(현Woncheon고이름,현Won고찾막Id,"<=","WON_ID","<=",현Won고찾막Id)
        
        ################## 3지점 읽은 이후 
        if 현Won고찾작Id_독행[1,"EPOCHMS"]<=ibDt_epochms<현Won고독정Id_독행[1,"EPOCHMS"]

            ################## 찾을 작막 아이디 갱신
            현Won고찾작Id=현Won고찾작Id_독행[1,"WON_ID"]
            현Won고찾막Id=현Won고독정Id_독행[1,"WON_ID"]

        elseif 현Won고독정Id_독행[1,"EPOCHMS"]<=ibDt_epochms<현Won고찾막Id_독행[1,"EPOCHMS"]

            ################## 찾을 작막 아이디 갱신
            현Won고찾작Id=현Won고독정Id_독행[1,"WON_ID"]
            현Won고찾막Id=현Won고찾막Id_독행[1,"WON_ID"]

        elseif ibDt_epochms==현Won고찾막Id_독행[1,"EPOCHMS"]  ## 찾은

            ################## 
            찾은Won고Id=현Won고찾막Id_독행[1,"WON_ID"]
            찾은Won고Epochms=현Won고찾막Id_독행[1,"EPOCHMS"]
            찾heureum=1004  ## 다 찾은 1004 부여

            break
        end

        ################## 다음번 찾을 작막 아이디차 범위 산출 판단
        현Won고찾IdDul_부mwe=현Won고찾막Id-현Won고찾작Id  ## 범위 산출

        if 현Won고찾IdDul_부mwe<=40*4*2

            찾heureum=2
        end
    end

    ############################# 와일 이후 나머지 순차 찾기 
    if 찾heureum==2

        ################## 준비
        현독Woncheon고=참고로Df(현Woncheon고이름,현Won고찾작Id,"<=","WON_ID","<=",현Won고찾막Id)

        현DeEpochms차Jd=Inf
        현찾은Won고Id=nothing
        현찾은Won고Epochms=nothing

        ################## 포문 본격
        for ffa in 1:nrow(현독Woncheon고)

            현독행Epochms=현독Woncheon고[ffa,"EPOCHMS"]

            현독행Epochms차Jd=abs(현독행Epochms-ibDt_epochms)

            if 현독행Epochms차Jd==0  ## 차이 0- 찾은

                현찾은Won고Id=현독Woncheon고[ffa,"WON_ID"]
                현찾은Won고Epochms=현독Woncheon고[ffa,"EPOCHMS"]
                break 

            else  ## 차이 유- 찾는 중

                if 현DeEpochms차Jd>현독행Epochms차Jd

                    현DeEpochms차Jd=현독행Epochms차Jd

                    현찾은Won고Id=현독Woncheon고[ffa,"WON_ID"]
                    현찾은Won고Epochms=현독Woncheon고[ffa,"EPOCHMS"]
                end
            end
        end

        ################## 결. 포문 종료 후 확정
        찾은Won고Id=현찾은Won고Id
        찾은Won고Epochms=현찾은Won고Epochms
    end

    ##################
    찾은Won고EpochmsDt=다tes.epochms2다tetime(찾은Won고Epochms)

    ##################
    rra_dict=Dict()

    push!(rra_dict,"고이름"=>현Woncheon고이름)
    push!(rra_dict,"WON_ID"=>찾은Won고Id)
    push!(rra_dict,"찾은_EPOCHMS"=>찾은Won고Epochms)
    push!(rra_dict,"찾은_EPOCHMS_DT"=>찾은Won고EpochmsDt)

    return rra_dict
end




################
# 맨 앞 dt로참고WoncheonId_dict 조작만으로 epochms 로 날고 아이디 찾기 변용 가능.
# dt로참고날Id_dict(현Dt)
function dt로참고날Id_dict(ibDt,slIn=1)

    #################### dt 으로 원천 아이디 찾고 원천에서 할 일
    dt로참고WoncheonId_dictVV=dt로참고WoncheonId_dict(ibDt,slIn)
    전_won_id=dt로참고WoncheonId_dictVV["WON_ID"]
    # ## 결. 찾을 기준 원천 아이디

    ################
    if slIn==1

        현Won고이름=CHg01_sl_woncheon고이름

    elseif slIn==2

        현Won고이름=CHg01_in_woncheon고이름
    end

    현Woncheon_id수=색인De값(현Won고이름,"WON_ID")

    ################
    현찾은Won고Id_bi위치=전_won_id/현Woncheon_id수
    # ## 결. 비율 위치 구한. 

    #
    #################### 
    ################
    if slIn==1

        현날고이름=CHg01_sl_날고이름

    elseif slIn==2

        현날고이름=CHg01_in_날고이름
    end

    현날고_id수=색인De값(현날고이름,"날_ID")

    현독날고_idChi=현날고_id수*현찾은Won고Id_bi위치
    현독날고_idChi=Int(로und(현독날고_idChi))
    # ## 결. 날고에서 읽을 아이디 

    ################
    번Dum값=600  ## 손잡이

    현독날고_작번=현독날고_idChi-번Dum값
    현독날고_막번=현독날고_idChi+번Dum값
    ## 결. 읽을 날고 작막번 마련. 

    현독날Gaji=참고로Df(현날고이름,현독날고_작번,"<=","날_ID","<=",현독날고_막번)

    ################
    찾은날고Id=1004.1004

    for ffa in 1:nrow(현독날Gaji)

        현날고행=현독날Gaji[ffa:ffa,:]  ## 날고 1행인.

        if 현날고행[1,"시_WON_ID"]<=전_won_id<=현날고행[1,"막시_WON_ID"]

            찾은날고Id=현날고행[1,"날_ID"]  ## 결. 찾은.
        end
    end
    ## 찾은날고Id 산출한. 

    #
    ####################
    rra_dict=Dict()

    push!(rra_dict,"고이름"=>현날고이름)
    push!(rra_dict,"날_ID"=>찾은날고Id)
    push!(rra_dict,"찾은_EPOCHMS"=>dt로참고WoncheonId_dictVV["찾은_EPOCHMS"])
    push!(rra_dict,"찾은_EPOCHMS_DT"=>dt로참고WoncheonId_dictVV["찾은_EPOCHMS_DT"])

    return rra_dict
end




################ WON_ID 입력하면 해당하는 날_ID 반환
function 참고WoncheonId로_날고Id_dict(slIn,ib_won_id)

    ############################# 준비
    if slIn==1

        현날고이름=CHg01_sl_날고이름

    elseif slIn==2

        현날고이름=CHg01_in_날고이름
    end

    날고_id수=색인De값(현날고이름,"날_ID")

    ################## 와일당 찾을 작아이디 막아이디 부여
    현날고찾작Id=1
    현날고찾막Id=날고_id수

    ############################# 와일 본격
    찾은날고Id=nothing 
    찾heureum=0

    while 찾heureum==0

        ################## 독중아이디 산출
        현날고독정Id=(현날고찾작Id+현날고찾막Id)*0.5
        현날고독정Id=Int(로und(현날고독정Id))

        ################## 3지점 작,중,막 아이디 일기
        현날고찾작Id_독행=참고로Df(현날고이름,현날고찾작Id,"<=","날_ID","<=",현날고찾작Id)
        현날고독정Id_독행=참고로Df(현날고이름,현날고독정Id,"<=","날_ID","<=",현날고독정Id)
        현날고찾막Id_독행=참고로Df(현날고이름,현날고찾막Id,"<=","날_ID","<=",현날고찾막Id)

        ################## 3지점 읽은 이후 
        if 현날고찾작Id_독행[1,"시_WON_ID"]<=ib_won_id<=현날고독정Id_독행[1,"시_WON_ID"]

            ################## 찾을 작막 아이디 갱신
            현날고찾작Id=현날고찾작Id_독행[1,"날_ID"]
            현날고찾막Id=현날고독정Id_독행[1,"날_ID"]

        elseif 현날고독정Id_독행[1,"시_WON_ID"]<=ib_won_id<현날고찾막Id_독행[1,"시_WON_ID"]

            ################## 찾을 작막 아이디 갱신
            현날고찾작Id=현날고독정Id_독행[1,"날_ID"]
            현날고찾막Id=현날고찾막Id_독행[1,"날_ID"]

        elseif 현날고찾막Id_독행[1,"시_WON_ID"]<=ib_won_id<=현날고찾막Id_독행[1,"막시_WON_ID"]
            # ## 찾은

            ################## 
            찾은날고Id=현날고찾막Id_독행[1,"날_ID"]
            찾heureum=1004  ## 다 찾은 1004 부여

            break
        end

        ################## 다음번 찾을 작막 아이디차 범위 산출 판단
        현날고찾IdDul_부mwe=현날고찾막Id-현날고찾작Id  ## 범위 산출

        if 현날고찾IdDul_부mwe<=3

            찾heureum=2
        end
    end

    ############################# 와일 이후 나머지 순차 찾기 
    if 찾heureum==2

        ################## 준비
        현독날고=참고로Df(현날고이름,현날고찾작Id,"<=","날_ID","<=",현날고찾막Id)

        ################## 포문 본격
        for ffa in 1:nrow(현독날고)

            현독_시_won_id=현독날고[ffa,"시_WON_ID"]
            현독_막시_won_id=현독날고[ffa,"막시_WON_ID"]

            if 현독_시_won_id<=ib_won_id<=현독_막시_won_id  

                찾은날고Id=현독날고[ffa,"날_ID"]  ## 결. 찾은.
            end
        end
    end

    ################## 종. 
    rra_dict=Dict()

    push!(rra_dict,"고이름"=>현날고이름)
    push!(rra_dict,"날_ID"=>찾은날고Id)
 
    return rra_dict
end




################ 현재 참고의 마지막 정보 dict() 로 반환 - 실제고용
# 참고_sl_막Bo_dict(2)
function 참고_sl_막Bo_dict(won나다=1)
    # ## 원천고만 또는 다

    rra_dict=Dict()

    push!(rra_dict,"참고이름"=>참고이름)
    push!(rra_dict,"전산기_now"=>now())

    #################### 원천고
    ################# 원천고 기반
    현고테이블이름=CHg01_sl_woncheon고이름
    현색인="WON_ID"
    현색인De값VV=색인De값(현고테이블이름,현색인)

    현Df=참고로Df(현고테이블이름,현색인De값VV,"<=",현색인,"<=",현색인De값VV)
    현막기=현Df[end,"기"]
    현Epochms=현Df[end,"EPOCHMS"]
    현Dt=다tes.epochms2다tetime(현Epochms)

    push!(rra_dict,"WON고_막_WON_ID"=>현색인De값VV)
    push!(rra_dict,"WON고_막_기_won고Ban"=>현막기)
    push!(rra_dict,"WON고_막_EPOCHMS_won고Ban"=>현Epochms)
    push!(rra_dict,"WON고_막_DT_won고Ban"=>현Dt)

    현Epochms_jigu=현Df[end,"EPOCHMS_JIGU"]
    현Dt_jigu=다tes.epochms2다tetime(현Epochms_jigu)

    push!(rra_dict,"WON고_막_EPOCHMS_JIGU_won고Ban"=>현Epochms_jigu)
    push!(rra_dict,"WON고_막_DT_JIGU_won고Ban"=>현Dt_jigu)

    ################# 날고 기반
    sl_날_막Id=색인De값(CHg01_sl_날고이름,"날_ID")

    날고막날=참고로Df(CHg01_sl_날고이름,sl_날_막Id,"<=","날_ID","<=",sl_날_막Id)

    현작Id=날고막날[1,"시_WON_ID"]
    현막Id=날고막날[1,"막시_WON_ID"]

    won고독=참고로Df(CHg01_sl_woncheon고이름,현작Id,"<=","WON_ID","<=",현막Id)
    # ## 결. 원천고 읽은

    현막기2=won고독[end,"기"]
    현Epochms2=won고독[end,"EPOCHMS"]
    현Dt2=다tes.epochms2다tetime(현Epochms2)

    push!(rra_dict,"WON고_막_기_날고Ban"=>현막기2)
    push!(rra_dict,"WON고_막_EPOCHMS_날고Ban"=>현Epochms2)
    push!(rra_dict,"WON고_막_DT_날고Ban"=>현Dt2)

    현Epochms2_jigu=won고독[end,"EPOCHMS_JIGU"]
    현Dt2_jigu=다tes.epochms2다tetime(현Epochms2_jigu)

    push!(rra_dict,"WON고_막_EPOCHMS_JIGU_날고Ban"=>현Epochms2_jigu)
    push!(rra_dict,"WON고_막_DT_JIGU_날고Ban"=>현Dt2_jigu)
    
    #
    ####################
    if won나다==2  ## 전체 다 할시 
        
        #
        #################### 가지25 고 
        현고테이블이름=CHg01_sl_gaji25고이름
        현색인="GAJI25_ID"
        현색인De값VV=색인De값(현고테이블이름,현색인)

        push!(rra_dict,"GAJI25고_막_GAJI25_ID"=>현색인De값VV)

        #################### 가지50 고 
        현고테이블이름=CHg01_sl_gaji50고이름
        현색인="GAJI50_ID"
        현색인De값VV=색인De값(현고테이블이름,현색인)

        push!(rra_dict,"GAJI50고_막_GAJI50_ID"=>현색인De값VV)

        #################### 가지50 고 
        현고테이블이름=CHg01_sl_gaji100고이름
        현색인="GAJI100_ID"
        현색인De값VV=색인De값(현고테이블이름,현색인)

        push!(rra_dict,"GAJI100고_막_GAJI100_ID"=>현색인De값VV)

        #
        #################### 접합고 
        현고테이블이름=CHg01_sl_jub하b고이름
        현색인="JUB_ID"
        현색인De값VV=색인De값(현고테이블이름,현색인)

        push!(rra_dict,"JUB고_막_JUB_ID"=>현색인De값VV)

        #
        #################### 날고 
        현고테이블이름=CHg01_sl_날고이름
        현색인="날_ID"
        현색인De값VV=색인De값(현고테이블이름,현색인)

        push!(rra_dict,"날고_막_날_ID"=>현색인De값VV)
    end

    #################### 참고에 록 기록
    readdirVV=readdir(참고입구총)

    록_file_이름="참고_sl_막Bo_dict들.bb"
    현_file_총=참고입구총*"\\"*록_file_이름

    if 록_file_이름 ∉ readdirVV

        se_bb=[rra_dict]

    elseif 록_file_이름 ∈ readdirVV

        gu_bb=deserialize(현_file_총)

        se_bb=copy(gu_bb)
        push!(se_bb,rra_dict)

        rm(현_file_총,recur시ve=true)
    end

    serialize(현_file_총,se_bb)  ## 기록

    return rra_dict
end




################
# 답사날들수 입력하면 날고 중 작아이디, 막아이디 반환함.
function 참고날고_정작막번(slIn,답sa날들수변수,kkallin고막Umu)
    # ## 입력: 깔린고막유무- 1 유, 2 무

    if kkallin고막Umu==1

        tec고막번=색인De값(CHg01_sl_날고이름,"날_ID")
        현작번=tec고막번-답sa날들수변수+1

        rra=[slIn,현작번,tec고막번]
        # ## 이 함축 종에서 반환

    elseif kkallin고막Umu==2

        ################################## 답사시험 시작번,막번 산출 원
        ################ 앞쪽 준비
        if slIn==1

            duijil날고이름=CHg01_sl_날고이름
            duijil고작Id=sl_고In정작날번
            duijil고막Id=sl_날_막Id=색인De값(duijil날고이름,"날_ID")

        elseif slIn==2

            duijil날고이름=CHg01_in_날고이름
            duijil고작Id=in_고In정작날번
            duijil고막Id=색인De값(duijil날고이름,"날_ID")
        end

        ################ 날고번호 뽑기- 답sa날들수변수 는 입력된 손잡이
        현Rand막번=duijil고막Id-답sa날들수변수+1  
        # ## 작번을 뽑을 거니까 입력 막번을 앞으로 밀어놔야 한다.
        현Rand작번=duijil고작Id

        # hum날Gaji_답saHum작번=rand(현Rand작번:현Rand막번)
        hum날Gaji_답saHum작번=나n수하나_biyulBs(현Rand작번,현Rand막번,[2,3,2,1,2,3,4])
        # ## 비율 손잡이
        hum날Gaji_답saHum막번=hum날Gaji_답saHum작번+답sa날들수변수-1
        ## 결. 답사시험의 작막번 마련.

        rra=[slIn,hum날Gaji_답saHum작번,hum날Gaji_답saHum막번]  
        # ## 이 함축 종에서 반환
    end

    return rra
end




################
function 참고날고_작막번로_woncheonDf(jan막번_rra)

    ################ 자료고명 마련
    if slIn==1

        duijil날고이름=CHg01_sl_날고이름
        duijilWon고이름=CHg01_sl_woncheon고이름

    elseif slIn==2

        duijil날고이름=CHg01_in_날고이름
        duijilWon고이름=CHg01_in_woncheon고이름
    end

    ################ 날고 읽기
    현독날고=참고로Df(duijil날고이름,jan막번_rra[2],"<=","날_ID","<=",jan막번_rra[3])
    # ## 결. 날고 읽은 

    ################ 날작막번들 마련- df 안내 행번 준
    현Du수=1-현독날고[1,"시_WON_ID"]  ## 이걸 더하면 안내 행번이 됨 # 대체로 음양 음 

    df날작막번들=Vector()

    for ffa in 1:nrow(현독날고)

        현Df작번=현독날고[ffa,"시_WON_ID"]+현Du수
        현Df막번=현독날고[ffa,"막시_WON_ID"]+현Du수

        현Df작막번=[현Df작번,현Df막번]

        push!(df날작막번들,copy(현Df작막번))  ## 결. 작막번들 붙이기 # [작번,막번]
    end

    ################ 원천 읽어 df 만들기 
    df_woncheon=
    참고로Df(duijilWon고이름,현독날고[1,"시_WON_ID"],"<=","WON_ID","<=",현독날고[end,"막시_WON_ID"])
    # ## 결. 원천 읽은.

    ################
    rra=[df날작막번들,df_woncheon]

    return rra
end




############################################ 참고 예비 ############################################
################ 참고예비 Cgy 전
function 참고Yebi전(drive,yebi고이름,deung번변수)
    # ## 입력: 예비할 드라이브,예비할 고이름,각 테이블을 몇 등분할 건지

    global Cgy_입구총=drive*":\\"*yebi고이름  ## "D:\\참고Yebi"

    global Cgy_테이블_deung번=deung번변수
end




################ 깔린 참고의 테이블 폴더들을 그대로 옮기는 것
function Cgy_yebi고_폴더들_성(현테이블들=[])
    # ## 입력: 현재대상테이블들- [CHg01_sl_woncheon고이름] 이런식.

    if 현테이블들==[]

        readdirVV=readdir(참고입구총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        for ffa in 1:length(readdirVV)

            현MkPathString=Cgy_입구총*"\\"*readdirVV[ffa]

            mkpath(현MkPathString)  ## 결. 만들기  
        end
    else

        for ffa in 1:length(현테이블들)

            현테이블=현테이블들[ffa]

            현MkPathString=Cgy_입구총*"\\"*현테이블

            mkpath(현MkPathString)  ## 결. 만들기  
        end
    end
end




################ 테이블이름 입력하면 그 테이블의 색인대값 반환함
function Cgy_테이블이름로_pilyo들(테이블이름)

    splitVV=split(테이블이름,"_")

    if splitVV[end]=="WONCHEON"

        테이블형="WON"
        id이름="WON_ID"
        로고시색인=[id이름]

    elseif splitVV[end]=="GAJI25"

        테이블형="GAJI"
        id이름="GAJI25_ID"
        로고시색인=[id이름,"시_WON_ID"]

    elseif splitVV[end]=="GAJI50"

        테이블형="GAJI"
        id이름="GAJI50_ID"
        로고시색인=[id이름,"시_WON_ID"]

    elseif splitVV[end]=="GAJI100"

        테이블형="GAJI"
        id이름="GAJI100_ID"
        로고시색인=[id이름,"시_WON_ID"]

    elseif splitVV[end]=="JUB하B"

        테이블형="JUB"
        id이름="JUB_ID"
        로고시색인=[id이름,"시_WON_ID"]

    elseif splitVV[end]=="날"

        테이블형="날"
        id이름="날_ID"
        로고시색인=[id이름,"시_WON_ID"]
    
    elseif splitVV[end]=="ICGE"

        테이블형="MIPADO"
        id이름="AN내"
        로고시색인=[id이름]
    end

    색인De값VV=색인De값(테이블이름,id이름)

    return [테이블형,id이름,색인De값VV,로고시색인]
end




################ 입력받은 테이블을 예비하는 것
function Cgy_로Yebi(현테이블들=[])
    println("function Cgy_로Yebi 시작")

    #########################
    if 현테이블들==[]

        readdirVV=readdir(참고입구총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        할테이블들=copy(readdirVV)

    else

        할테이블들=copy(현테이블들)
    end

    #########################
    for ffa in 1:length(할테이블들)

        ################### 준비
        현테이블이름=할테이블들[ffa]

        println("Cgy_로Yebi ffa=$ffa 회 / 현테이블이름=$현테이블이름")

        Cgy_테이블이름로_pilyo들VV=Cgy_테이블이름로_pilyo들(현테이블이름)
        # ## 결. ["GAJI","GAJI100_ID",1234556]
        현테이블_id이름=Cgy_테이블이름로_pilyo들VV[2]
        현테이블_색인De값=Cgy_테이블이름로_pilyo들VV[3]

        ############### 포문 회전수 구하기
        하nHoi묶수=현테이블_색인De값/Cgy_테이블_deung번  ## 결. 한회당 묶을 수.
        하nHoi묶수=Int(찾은il(하nHoi묶수))

        divremVV=divrem(현테이블_색인De값,하nHoi묶수)

        if divremVV[2]==0

            forHoi전수=divremVV[1]

        else

            forHoi전수=divremVV[1]+1
        end
        ## 포문 회전수 구한.
        
        for ffb in 1:forHoi전수

            ############### 테이블 읽을 작막번 산출 - 참고는 테이블 막번 넘어도 됨.
            현독작번=하nHoi묶수*(ffb-1)+1
            현독막번=하nHoi묶수*ffb

            현테이블정독=참고로Df(현테이블이름,현독작번,"<=",현테이블_id이름,"<=",현독막번)
            # ## 결. 테이블 중에서 작막번으로 끊어 읽은.

            현총총=Cgy_입구총*"\\"*현테이블이름*"\\"*"$ffb"*".Cgy"
            # ## 결. "D:\\참고Yebi\\AD고_2_JJOIL_TS_SL01_WONCHEON\\1.Cgy"

            println("Cgy_로Yebi ffb=$ffb 회 / 현재총총=$현총총 / 시작")

            serialize(현총총,현테이블정독)  ## 종. 예비 로고.

            println("Cgy_로Yebi ffb=$ffb 회 / 현재총총=$현총총 / 막")
        end
    end

    println("function Cgy_로Yebi 끝")
end




################ 종. 테이블 이름 입력하여 예비. # 입력 안하면 전체 테이블 예비함.
function Cgy_테이블들로Yebi(현테이블들=[])
    println("function Cgy_테이블들로Yebi 시작")

    Cgy_yebi고_폴더들_성(현테이블들)
    Cgy_로Yebi(현테이블들)

    println("function Cgy_테이블들로Yebi 끝")
end




################ 예비에서 다시 정식 참고로 복원
function Cgy_yebi로참고(현테이블들=[])
    println("function Cgy_yebi로참고 시작")

    #########################
    if 현테이블들==[]

        readdirVV=readdir(Cgy_입구총)
        readdirVV=참고원소이름_정률(readdirVV,1)

        할테이블들=copy(readdirVV)

    else

        할테이블들=copy(현테이블들)
    end

    #########################
    for ffa in 1:length(할테이블들)

        ################### 준비
        현테이블이름=할테이블들[ffa]

        println("Cgy_yebi로참고 ffa=$ffa 회 / 현테이블이름=$현테이블이름")

        Cgy_테이블이름로_pilyo들VV=Cgy_테이블이름로_pilyo들(현테이블이름)
        # ## 결. ["GAJI","GAJI100_ID",1234556]

        ############## 테이블 총 읽기 - ["1","2","3",...]
        현테이블총=Cgy_입구총*"\\"*현테이블이름
        readdirVV2=readdir(현테이블총)  ## "10.Cgy","11.Cgy"
        readdirVV2=참고원소이름_정률(readdirVV2,1)
        현테이블De번=length(readdirVV2)  ## 결. 몇 개 퍄일이 있나. 
        # # 모든 참고예비 퍄일은 1,2,3,... 순서이니까.

        for ffb in 1:현테이블De번

            현File만이름=readdirVV2[ffb]
            현독D변수ile이름=현테이블총*"\\"*현File만이름
            # ## 결. "D:\\참고Yebi\\AD고_2_JJOIL_TS_SL01_WONCHEON\\1.Cgy"

            println("Cgy_yebi로참고 ffb=$ffb 회 / 현독D변수ile이름=$현독D변수ile이름 / 시작")

            현독D변수ile=deserialize(현독D변수ile이름)  ## 결. 퍄일 읽은.

            df로참고VV=
            df로참고(Cgy_테이블이름로_pilyo들VV[1],현테이블이름,현독D변수ile,Cgy_테이블이름로_pilyo들VV[4])
            # ## 종. 로고한.

            println("Cgy_yebi로참고 ffb=$ffb 회 / 현독D변수ile이름=$현독D변수ile이름 / 막")
        end
    end

    println("function Cgy_yebi로참고 끝")
end




################
function 날고날_id로_woncheonDf(slIn,ib_날_id)

    if slIn==1

        현독날고이름=CHg01_sl_날고이름
        현독Woncheon고이름=CHg01_sl_woncheon고이름

    elseif slIn==2

        현독날고이름=CHg01_in_날고이름
        현독Woncheon고이름=CHg01_in_woncheon고이름
    end

    현독날고=참고로Df(현독날고이름,ib_날_id,"<=","날_ID","<=",ib_날_id)

    ################
    현독Woncheon고=참고로Df(현독Woncheon고이름,
    현독날고[1,"시_WON_ID"],"<=","WON_ID","<=",현독날고[1,"막시_WON_ID"])

    return 현독Woncheon고
end




################
function 날고막Id_수nhum날수_boonjul로_날작막번Dul들(수nhum날수,boonjul=9)

    tec날고막번=색인De값(CHg01_sl_날고이름,"날_ID")

    joon_날작막번차=Int(찾은il(수nhum날수/boonjul))

    날고작번=tec날고막번-(수nhum날수-1)

    ################
    현날작막번Dul들=Vector()
  
    for ffa in 날고작번:joon_날작막번차:tec날고막번
       
        현날고작번=ffa
        현날고막번=현날고작번+(joon_날작막번차-1)

        if 현날고막번>tec날고막번

            현날고막번=tec날고막번
        end

        현날작막번Dul=[현날고작번,현날고막번]
        push!(현날작막번Dul들,copy(현날작막번Dul))
    end

    return 현날작막번Dul들
end




################
function 수nhum_날_id_날록_폴더독_할_날_id_maryeun(수nhum_폴더이름,작_날_id,막_날_id)

    readdirVV=readdir(참고입구총)
    수nhum_폴더_총="$(참고입구총)\\$(수nhum_폴더이름)"

    if 수nhum_폴더이름 ∉ readdirVV

        mkpath(수nhum_폴더_총)  ## 결. 만들기 

        ################
        찾은_날_id=rand(작_날_id:막_날_id)
        
        return 찾은_날_id
    end
    ## 선험 폴더 있는.

    #
    ################ 날_id 모으기
    록_file들=readdir(수nhum_폴더_총)

    현_록_날_id들=Vector()
 
    for ffa in 1:length(록_file들)
        
        ################
        현_록_file이름=록_file들[ffa]
        splitVV=split(현_록_file이름,".")
        splitVV2=split(splitVV[1],"_")

        현_록_날_id=parse(Int,splitVV2[end])  ## 결.
        push!(현_록_날_id들,현_록_날_id)
    end

    ################
    날록들_df=다taFrame(날_id=현_록_날_id들)
    sort!(날록들_df,"날_id")

    날_id들=copy(날록들_df[:,"날_id"])  ## 결.

    #
    ################
    찾은_날_id=nothing 

    for ffa in 1:30

        날_id_rand=rand(작_날_id:막_날_id)

        if 날_id_rand ∉ 날_id들

            찾은_날_id=날_id_rand
        end
    end

    ################
    if 찾은_날_id==nothing

        ffa2=1

        for ffa in 작_날_id:막_날_id

            ffa2+=1

            ################
            if ffa2<=length(날_id들)

                현_날_id_dul차=날_id들[ffa2]-날_id들[ffa2-1]

                if 현_날_id_dul차>=2

                    찾은_날_id=날_id들[ffa2-1]+1  ## 결.
                end

            else

                찾은_날_id=날_id들[end]+1
            end

            ################
            if 찾은_날_id !=nothing

                break
            end
        end
    end

    return 찾은_날_id
end




################ 참고예비 끄적
"""
######### 삭제
고형="MIPADO"
고테이블이름="AD고_2_JJOIL_TS_MIPADO_ICGE"
색인="AN내"
ujiDe값=40
막행부tu_sacje(고형,고테이블이름,색인,ujiDe값)

######### 참고에서 예비 퍄일들로
참고전(전산기,참고이름,100,4)
참고Yebi전("D","참고Yebi_째u로",20)
Cgy_테이블들로Yebi([CHg01_sl_gaji25고이름,CHg01_sl_gaji50고이름,CHg01_sl_gaji100고이름,CHg01_sl_jub하b고이름,CHg01_sl_날고이름])  
# ## 현테이블들=[]

######### 참고예비에서 정식 참고로
참고전(전산기,참고이름,100,4)
참고Yebi전("D","참고Yebi_째u로",20)  ## "B:\\참고Yebi_jj고ld" 폴더에 예비 퍄일이 모두 있어야 함.
Cgy_yebi로참고([CHg01_sl_gaji100고이름,CHg01_sl_jub하b고이름,CHg01_sl_날고이름])  ## 현테이블들=[]
"""

