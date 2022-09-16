

/* 
일반 종목이 아닌 마이크로용으로 쓸시 hhMarketCode=MarketData1.code; 선택.
ibjangBhBsSiC=hhNalOpen; hhJnibJumungaC=hhNalOpen-(CHg01_hanguc_soDongTick*jumun_jangjun_gesu); 
등 이 hhMarketC 였는데 hhNalOpen 로 한 상태다.

2021년 11월 5일. 오전 7시39분.
줄리아 마리아디비가 기존엔 매봉 수출 방식이었는데 이제 변발 수출 방식으로 바뀌었다. 
그에 맞춘 예스스팟 짠의 수정을 마친 최초 상태다. 실전 배치 대기 중임.

2021년 11월 10일. 오후 12시34분.
포지션 100 중 어떤 경우 포지션 1000이 되고, 줄리아 포지션 변화 감지로 취소 주문이 들어가는지 명확히함.
탈출 주문 미체결 대기중인데 줄리아 포지션이 보유 포지션과 동일한 향으로 날시,
포지션 1000을 유지하고 탈흐름은 0처리가 되어 흡수되는 기재를 만들었음. 

2021년 11월 14일. 오후 3시2분.
sql_rra_ibjangGo 의 배열방 순서가 바뀌었음. 줄리아에서부터 장전개수가 도입돼 sql 로 수출됨.
포지션 진행중 줄리아 포지션 발령이 역향이 나는 상황을 대처할 수 있게 수정하였음. 
juliaYesEumyangIlchi==0, juliaYesEumyangIlchi<1 을 구분해서. 또한 이럴 경우 
매회 읽는 sql 막행을 다시 읽어야 하는데 그 기재를 만듦.
talHeureumHu_sqlDasiDocUmu==1, hhDocDoinIbjangGoAnneBun-=1; 등.

2022년 3월 8일. 오후 2시 3분.
onUpdateAccount_doin 도입했음. 

2022년 3월 20일. 오후 10시38분.
AD_ibHeng_nalJung_9.js -> mi8Heng_bn_1_JJEURO() / mi8Heng_bn_2_JJEURO() 실행 사용.

2022년 5월 19일. 이게 예스트레이더 1틱 마다 갱신되는 것임. 청산시 시세 급변에 대응하는 주문 정정 기능 강화함.
1틱 마다 가격이 도망가는지 판단하여 너무 멀리 가면 중틱 준 봉수가 안채워 져도 주문 정정하는 기능.

2022년 5월 31일. 14Mk 가 이론상 아무런 문제가 없다고 본다. 
그런데 예스스팟의 이벤트 후처리 꼬임 문제로 추정되는 예스스팟 자체의 문제가 있어 그걸 회피하는 기재를 만든게 15Mk 다.

2022년 6월 27일. 자바스크립트로 쓰여진 예스스팟 짠은 한국 예스트레이더 준 소동틱만으로 돌아간다. 
줄리아에서 기만 받아오고 그 이후 그걸 C로 가공하여 활용하는 모든 것은 한국 예스트레이더 준 소동틱만이다.

2022년 7월 1일. 지금까지 짠 것들이 짠 상으로는 맞는 것이다. 그런데 시세가 빠를시 등, 주문 집행시 알 수 없는 이유로 오류가 날시 등,
이런 경우들이 있기 때문에 순환이 막히는 것으로 보인다. 입장 보유중 탈출 명령이 집행이 false 로 막히면 안된다.
그렇기 때문에 그 경우를 대비한 것이 21.js 퍄일이다.

2022년 7월 4일. 입장 100 중일때 줄리아 입장에 변화가 감지되어 그걸 처리하는 기재를 없애기로 했다. 
시세가 매우 빠를 경우가 종종 있는데 밸런스 객체의 보유 입장 수를 파악해서 입장 1000을 발령 하는 기본 개념이 시간이 걸리기 때문이다.
밸런스 객체 업데이트는 시간이 좀 걸리기에 그 시간적 여유를 고려해야만 이 전체 짠이 순환할 수 있다.

2022년 7월 5일. 주문후 도망시 orderReplace 가 5개 정도 가면 나는데 이거를 일정 봉수 지날때까지 놔두는게 23.js 이다. 
그 직전, 그러니까 입장 100 등에서 시세가 빠를시 입장 1000등을 가지 못하고 얽히고 꼬이는걸 최대한 회피하는 기재를 만들은게 22.js 이다.
*/




////////////// 손잡이부
var tableEreum="MI9BN_JJEURO_JOONIBJANG";  // 마리아디비 테이블 이름 - 종목별.
var jjBonNaMicro=2;  // 종목- 1 주종목이냐 2 마이크로냐
var jnibSuryang=3;  // 수동 진입 수량 - 매일 아침 - 종목별.
var CHg01_hanguc_soDongTick=0.00005;  // 한국 예스트레이더 준 소동틱 pricescale - 손잡이 - 종목별. 
// // - 한국, 미국 소동틱이 다를때 한국 예스트레이더 준 소동틱하면 됨.
var CHg01_hanguc_soDongTick_sosuJum_jarisu=5;  // 한국 예스트레이더 준 소동틱 pricescale 자릿수 // 오일 2, 골드 1, 유로 5
var jnib_micegyulSi_orderReplaceHu=1;  // 1 진입 주문 미체결시 따라가는 주문 정정, 0 해당 주문 취소
var jnib_jumunHoo_orderReplace_jacBongSu=14*14;  
// / 손잡이- 1틱 마다 갱신되는 
var tal_jumunHoo_orderReplace_jacBongSu=14*14;  // 손잡이- 1틱 마다 갱신되는 / 오일 14틱인데 그게 30봉 정도면 / 20이었다.
var talJumunSiTalGa_domang_orderReplace_tickGesu=5;  
// / 오일, 골드=18 / 유로=16 // 좌 이었는데 장전개수 +6개로 // 미8실시 골드 5개로 함.
var hhTalJumunGaCwaMarketCcha_injungGesu=10;  // 이 인정개수를 넘어서면 주문가를 줄리아 명령이 아닌 실시간 시장 데이터로 한다.
var jumunGa_bojungHu=1;
var talHeureum1Si_reFreshHu=1;

var heureumBhDoinCho1HooDasiRefreshBongSu=100;  // 적당한 간격

//////////////
var kkuenHooBongSu=0;

var hhGejwaBun=0;
var hhGejwaCongGeum=0;
var hhGnSuryang=0;
var choKkuenHeureum=1;
var sql_rra=0;
var sqlSelect="0";
var sql_rra_ibjangGo=new Array();
var fieldCountVV=0;

var roundSiGobSu=0;
var jumun_jangjun_gesu=0;  // 진포지션전개수 - 차트 종가가 10이면 6에서 진입하는
var tal_jangjun_gesu=0;  // 탈출장전개수
var jnib_cGanChaInjungGesu=100;  // 줄리아 종가와 예스트레이더 차트 종가간 차이 인정개수 - 보통 4,8

var jumunJoonCode="0";
var sqlSelect="0";
var sql_rra=0;

var hhJuliaGiC=0;
var hhJuliaIbjangJ1=0;
var hhJuliaIbjang=0;
var hhJuliaIbjangBhBs=0;
var hhJuliaIbjangSiJuliaGi=0;
var hhJuliaIbjangSiJuliaC=0;

var hhJJc=0;
var hhJnibJumungaC=0;
var hhJuliaCganCha=0;
var ibjang=0;
var ibjangBhBs=0;
var ibjangBhBsSiC=0;
var jn_jumunHoo_bongSu=0;

var unfill_orderNum=0;
var hhBalanceCount=0;
var orderIDvv=0;
var orderIDvvJ1=0;
var orderCountVV=0;
var juliaYesEumyangIlchi=0;
var talHeureum=0;
var hhBalanceCode="";
var hhBalanceCount=0;
var hhBalanceIbjang=0;
var hhDocDoinIbjangGoAnneBun=0;
var ibjangGoSeHengOn=0;
var heureumJoongheureum=0;
var heureumJoongheureumTal=0;

var orderId_1=0;
var orderId_81=0;
var orderId_jn_replace=0;
var orderId_810=0;
var orderId_10=0;
var orderId_tal_replace=0;

var orderId_1_orderNum=0;
var orderId_81_orderNum=0;
var orderId_jn_replace_orderNum=0;
var orderId_810_orderNum=0;
var orderId_10_orderNum=0;
var orderId_tal_replace_orderNum=0;

var hhUnfillOrder=0;

var hhTalJumunGac=0;
var talJumunHyang=0;
var tal_jumunHoo_bongSu=0;

var hhSuic=0;
var hhSuicNu=0;
var jnibNalHu=1;  // 날진입허가 - 줄리아의 범위보다 넓게 하는게 원칙 // 중간에 허가 무 0 될 수 있음.
var isNormalVV=false;
var orderNumVV=-1004;
var hhibjangJoon_unfillOrderNum=0;
var talHeureumHu_sqlDasiDocUmu=2;

var onUpdateAccount_doin=0;
var heureumBhDoinCho=0;
var hhTonggwaJoong=0;
var hhTalJumunGacwaMarketCcha=0;
var talJumunSiTalGac=0;
var talJumunSiTalGac_wa_hhC_cha=0;
var taljumunHoo_domang_orderReplace_ryung=0;
var juliaIbjangYucHyangRyung=0;
var tal_jangjun_gesuGyul=0;
var jumun_jangjun_gesu_juliaBhBsSi=0;

var hhTalJumunGaCwaMarketCchaGesu=0;
var order_errorMessage="";
var talHeureum2HooBongSu=0;

var jn_jumunHoo_orderJe_hoisu=0;
var ibjang100HooBongSu=0;
var heureumBhDoinCho1HooBongSu=0;

var hhAskC=0;
var hhBidC=0;




function Main_OnStart()
{
	Main.MessageList("AD ibjang heng sijac.");

	////////////// 반올림 보정시 사용되는
	roundSiGobSu=1/CHg01_hanguc_soDongTick;  // 오일준 100.0
	roundSiGobSu=Math.round(roundSiGobSu);

	Main.MessageList("계좌번호=",hhGejwaBun);
}




//////////////////////////
function Chart1_OnBarAppended(nData)
{
    if (nData==1){

        hhTonggwaJoong=0;

        kkuenHooBongSu+=1;
		hhJJc=Chart1.GetClose(nData,0);
        hhAskC=MarketData1.Ask(1);
        hhBidC=MarketData1.Bid(1);
		
		if (choKkuenHeureum==1){

            hhTonggwaJoong=1;

			////////////////// 일반 종목, 마이크로 종목에 따라 
            if (jjBonNaMicro==1){
				jumunJoonCode=Chart1.GetCode(1);  // AD_ibjang_JJEURO 
			} else if (jjBonNaMicro==2){
				jumunJoonCode=Chart2.GetCode(1);  // AD_ibjang_JJEUROm
			}

			sqlSelect="count(ANNE) from ";
			sqlSelect+=tableEreum;
			sqlSelect+=";";
			// Main.MessageList("sqlSelect=",sqlSelect);
			DataBase1.Select(sqlSelect,"AD");

			sql_rra=DataBase1.GetFieldValue(0);  // 첫 번째 컬럼이 0 임. 
			// Main.MessageList("sql_rra=",sql_rra);

			if (sql_rra>=1){

				////////////// 포지션고 읽기
				sqlSelect="* from ";
				sqlSelect+=tableEreum;
				sqlSelect+=" ORDER BY ANNE DESC LIMIT 1;";

				// Main.MessageList("sqlSelect=",sqlSelect);
				DataBase1.Select(sqlSelect,"AD");

				fieldCountVV=DataBase1.GetFieldCount();

				for (var i=0; i<=fieldCountVV-1; i++){
					sql_rra_ibjangGo[i]=DataBase1.GetFieldValue(i);  // 결. 배열에 마지막 행 배치한.
				}

				////////////// 줄리아 포지션 1식 발령시만 흐름 부여
				if (Math.abs(sql_rra_ibjangGo[5])==1){

					choKkuenHeureum=2;  // 실시간 포지션 수출이 시작됐으면 흐름 2 영구 부여.

                    ////////////// hhDocDoinIbjangGoAnneBun - 이 부분이 있어서 에이디 참 합동 매매 가능함.
                    hhDocDoinIbjangGoAnneBun=sql_rra_ibjangGo[0]-1;
				}
			}
		}

		if (choKkuenHeureum==2){

            hhTonggwaJoong=2;

			////////////// 순환 앞일
			// Main.MessageList("isNormalVV=",isNormalVV);

			ibjangBhBs=0;  // 처리일

			//
			////////////// 포지션고 읽기
			sqlSelect="* from ";
			sqlSelect+=tableEreum;
			sqlSelect+=" ORDER BY ANNE DESC LIMIT 1;";

			// Main.MessageList("sqlSelect=",sqlSelect);
			DataBase1.Select(sqlSelect,"AD");

			fieldCountVV=DataBase1.GetFieldCount();

			for (var i=0; i<=fieldCountVV-1; i++){
				sql_rra_ibjangGo[i]=DataBase1.GetFieldValue(i);  // 결. 배열에 마지막 행 배치한.
			}

            hhTonggwaJoong=21;

			////////////// 포지션고 새행 온 변수 발령
			ibjangGoSeHengOn=0;

			if (sql_rra_ibjangGo[0]!=hhDocDoinIbjangGoAnneBun){

				ibjangGoSeHengOn=1004;  // 줄리아 포지션 새 포지션 발령 1004 부여
				hhDocDoinIbjangGoAnneBun=sql_rra_ibjangGo[0];

                hhTonggwaJoong=22;
			}

			// Main.MessageList("줄리아 포지션고 새행 온 ibjangGoSeHengOn=",ibjangGoSeHengOn);

			//
			////////////// 줄리아 포지션 파악 변발부
			hhJuliaIbjangBhBs=0;  // 처리일

            jumun_jangjun_gesu=0;  // 처리일
            
			if (ibjangGoSeHengOn==1004){

                hhTonggwaJoong=31;

                //////// 변발 산출
                hhJuliaIbjangJ1=hhJuliaIbjang;

                hhJuliaIbjangBhBs=sql_rra_ibjangGo[5];  // 결. 줄리아 포지션변발 갱신.
                hhJuliaIbjang=sql_rra_ibjangGo[6];  // 결. 줄리아 포지션 갱신.

                jumun_jangjun_gesu=sql_rra_ibjangGo[7]; 
                jumun_jangjun_gesu_juliaBhBsSi=sql_rra_ibjangGo[7]; 

				//////// 줄리아 포지션 변발부
				if (Math.abs(hhJuliaIbjangBhBs)==1){

					hhJuliaIbjangSiJuliaGi=sql_rra_ibjangGo[4];  // SANSI_GI
					hhJuliaIbjangSiJuliaC=hhJuliaIbjangSiJuliaGi*CHg01_hanguc_soDongTick;  // C 가 된. 

				} else if (Math.abs(hhJuliaIbjangBhBs)==10){

					hhJuliaIbjangSiJuliaGi=sql_rra_ibjangGo[4];  // SANSI_GI
					hhJuliaIbjangSiJuliaC=hhJuliaIbjangSiJuliaGi*CHg01_hanguc_soDongTick;  // C 가 된. 
				}
			}

            ////////////// 새행 왔는데 미체결 남아 있을시 취소하는 
            /*
            if (ibjangGoSeHengOn==1004){

                if (Math.abs(ibjang)==100){

                    Account1.SetBalanceItem(jumunJoonCode,0);

                    ////////// 미체결
                    hhUnfillOrder=Account1.SetUnfillOrderNumber(orderNumVV); 
                    unfill_orderNum=Account1.Unfill.orderNum;

                    hhBalanceCount=Account1.Balance.count;  // 결. 현재 잔고 수량.
                    hhBalanceIbjang=Account1.Balance.position;

                    if (hhBalanceCount==0){

                        ibjang=0;

                        hhTonggwaJoong=3001;
                        Account1.OrderCancel(unfill_orderNum);
                    }
                }
            }
            */

			// Main.MessageList("줄리아 포지션변발 hhJuliaIbjangBhBs=",hhJuliaIbjangBhBs);

			//
			//////////////////////////// 본격
			if (talHeureum==0){

                hhTonggwaJoong=9999;

				if (ibjang==0){  // 포지션 0 시 

                    hhTonggwaJoong=10000;

					Account1.SetUnfillOrderNumber(orderNumVV);  // 미체결 
					hhibjangJoon_unfillOrderNum=Account1.Unfill.orderNum;

					////////////// 마지막 행 읽은 이후 
					hhJuliaGiC=sql_rra_ibjangGo[4]*CHg01_hanguc_soDongTick;
                    hhJuliaGiC=hhJuliaGiC.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);

					hhJuliaCganCha=hhJJc-hhJuliaGiC;

                    //////////////
                    Account1.SetBalanceItem(jumunJoonCode,0);
                    hhBalanceCount=Account1.Balance.count;

					if (Math.abs(hhJuliaCganCha)<=CHg01_hanguc_soDongTick*jnib_cGanChaInjungGesu && hhBalanceCount==0){  
						// 줄리아 산시기(종가) 와 차이가 인정개수 이내여야만 통과

                        hhTonggwaJoong=10010;

						if (hhJuliaIbjangBhBs==1 && jnibNalHu==1){  // 상방 진입

                            hhTonggwaJoong=10001;
							
							jn_jumunHoo_bongSu=1;
							ibjang=10;  // 결. 포지션 부여.
							ibjangBhBs=10;
						
							hhJnibJumungaC=hhJuliaIbjangSiJuliaC-(CHg01_hanguc_soDongTick*jumun_jangjun_gesu);  // 진입 장전가
							
							////////////////// hhJnibJumungaC 보정
                            if (jumunGa_bojungHu==1){

                                if (hhJnibJumungaC>hhBidC){
                                    hhJnibJumungaC=hhBidC+(CHg01_hanguc_soDongTick*1);
                                }
                            }

                            hhJnibJumungaC=hhJnibJumungaC.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);

							Main.MessageList("상방 진입 주문하는");
							orderId_1=Account1.OrderBuy(jumunJoonCode,jnibSuryang,hhJnibJumungaC,2);  // 결. 진입 주문 접수.
							
						} else if (hhJuliaIbjangBhBs==-1 && jnibNalHu==1){  // 하방 진입

                            hhTonggwaJoong=10002;

							jn_jumunHoo_bongSu=1;
							ibjang=-10;  // 결. 포지션 부여.
							ibjangBhBs=-10;
						
							hhJnibJumungaC=hhJuliaIbjangSiJuliaC+(CHg01_hanguc_soDongTick*jumun_jangjun_gesu);  // 진입 장전가
							
							////////////////// hhJnibJumungaC 보정
                            if (jumunGa_bojungHu==1){

                                if (hhJnibJumungaC<hhAskC){
                                    hhJnibJumungaC=hhAskC-(CHg01_hanguc_soDongTick*1);
                                }
                            }

                            hhJnibJumungaC=hhJnibJumungaC.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);

							Main.MessageList("하방 진입 주문하는");
							orderId_81=Account1.OrderSell(jumunJoonCode,jnibSuryang,hhJnibJumungaC,2);  // 결. 진입 주문 접수.
						}
					}
				} 
                
                if (Math.abs(ibjang)==10){  // 진입 주문 접수 상태

                    hhTonggwaJoong=1011;
                    ibjang=ibjang*10;  // 포지션 100 된.
                    ibjangBhBs=ibjang; 
                    ibjang100HooBongSu=0;
                    heureumBhDoinCho=1;
                    heureumBhDoinCho1HooBongSu=1;
				} 
                
                if (Math.abs(ibjang)==100){  // 진입 주문 정상 접수된 상태

                    hhTonggwaJoong=100100;
                    ibjang100HooBongSu+=1;
					jn_jumunHoo_bongSu+=1;

                    if (heureumBhDoinCho==1){

                        hhTonggwaJoong=1001;
                        heureumBhDoinCho=0;
                        onUpdateAccount_doin=0;

                        Account1.Refresh();
                    }

                    //////////////
                    heureumBhDoinCho1HooBongSu+=1;

                    if (heureumBhDoinCho1HooBongSu>=heureumBhDoinCho1HooDasiRefreshBongSu){

                        heureumBhDoinCho1HooBongSu=1;
                        Account1.Refresh();
                    }

                    //////////////
                    if (onUpdateAccount_doin==1){

                        hhTonggwaJoong=1002;
                        Account1.SetBalanceItem(jumunJoonCode,0);

                        ////////// 미체결
                        hhUnfillOrder=Account1.SetUnfillOrderNumber(orderNumVV); 
                        unfill_orderNum=Account1.Unfill.orderNum;
                        unfill_count=Account1.Unfill.count;  // 미체결

                        hhBalanceCount=Account1.Balance.count;  // 결. 현재 잔고 수량.
                        hhBalanceIbjang=Account1.Balance.position;

                        if (hhBalanceCount>=1 && hhBalanceCount==jnibSuryang){  // 전량 체결시 - 포지션 다음 1000으로

                            hhTonggwaJoong=1003;
                            ibjang=ibjang*10;  // 포지션 1000 된.
                            ibjangBhBs=ibjang; 
                            heureumBhDoinCho=1;
                            heureumBhDoinCho1HooBongSu=1;

                        } else if (hhBalanceCount<jnibSuryang && jn_jumunHoo_bongSu>=jnib_jumunHoo_orderReplace_jacBongSu){  // 미체결 유시 // 손잡이 16봉

                            hhTonggwaJoong=10040;

                            if (jnib_micegyulSi_orderReplaceHu==0){  // 0 해당 주문 취소 갈래

                                if (hhBalanceCount==0){  // 전체 물량 미체결시

                                    hhTonggwaJoong=1004;
                                    ibjang=0;
                                    // jnibNalHu=0;  // 이 경우 이 날은 진입 허가 무 처리

                                } else if (hhBalanceCount>=1){  // 일부 물량은 체결시

                                    ibjang=ibjang*10;  // 포지션 1000 된.
                                    ibjangBhBs=ibjang; 
                                    heureumBhDoinCho=1;
                                    heureumBhDoinCho1HooBongSu=1;
                                }

                                hhTonggwaJoong=1005;
                                Main.MessageList("포지션 100에서 미체결되어 취소 넣은");	
                                Account1.OrderCancel(unfill_orderNum);

                            } else if (jnib_micegyulSi_orderReplaceHu==1){  // 1 진입 주문 미체결시 따라가는 주문 정정

                                if (hhBalanceCount==0){  // 전체 물량 미체결시
                                    
                                    hhTonggwaJoong=1006;
                                    jn_jumunHoo_bongSu=0;

                                    ////////////// mi7Heng_bn 준으로 진입정정가씨 마련
                                    if (ibjang>0){

                                        hhJnibJumungaC=hhJJc+(CHg01_hanguc_soDongTick*1);

                                    } else if (ibjang<0){

                                        hhJnibJumungaC=hhJJc-(CHg01_hanguc_soDongTick*1);
                                    }

                                    hhJnibJumungaC=hhJnibJumungaC.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);

                                    //////////////
                                    if (jn_jumunHoo_orderJe_hoisu<=3){

                                        jn_jumunHoo_orderJe_hoisu+=1;
                                        orderId_jn_replace=Account1.OrderReplace(unfill_orderNum,unfill_count,hhJnibJumungaC);	

                                    } else {

                                        ibjang=0;
                                        jn_jumunHoo_orderJe_hoisu=0;
                                    }

                                } else if (hhBalanceCount>=1){  // 일부 물량은 체결시

                                    ibjang=ibjang*10;  // 포지션 1000 된.
                                    ibjangBhBs=ibjang; 
                                    heureumBhDoinCho=1;
                                    heureumBhDoinCho1HooBongSu=1;

                                    Main.MessageList("포지션 100에서 일부 체결되고 일부 미체결되어 일부를 취소 넣은");		
                                    Account1.OrderCancel(unfill_orderNum);
                                }
                            }

                        } else if (ibjang100HooBongSu>=jnib_jumunHoo_orderReplace_jacBongSu){

                            heureumBhDoinCho=1;  // 다시 부여
                            heureumBhDoinCho1HooBongSu=1;
                            jn_jumunHoo_bongSu=0;
                        }
                    }

					/////////////////// 줄리아 포지션 바뀌었는지 확인
                    /*
					juliaYesEumyangIlchi=sql_rra_ibjangGo[6]*ibjang;

					if (juliaYesEumyangIlchi<=0 && Math.abs(ibjang)==100){  // 포지션 1000이 못 됐을시만 통과

                        if (juliaYesEumyangIlchi<0){  // 줄리아 포지션 역향 발령시
                            hhDocDoinIbjangGoAnneBun-=1;  // 줄리아고 행 다시 읽기 가능 부여
                        }
						
						Main.MessageList("예스스팟 포지션 100 중, 포지션 반대 전환을 위해 취소 접수 넣은");
						
						ibjang=0;
						Account1.OrderCancel(unfill_orderNum);
					}
                    */

				} else if (Math.abs(ibjang)==1000){  // 진입 성공하여 진행중

                    if (heureumBhDoinCho==1){

                        heureumBhDoinCho=0;
                        onUpdateAccount_doin=0;

                        Account1.Refresh();
                    }

                    //////////////
                    heureumBhDoinCho1HooBongSu+=1;

                    if (heureumBhDoinCho1HooBongSu>=heureumBhDoinCho1HooDasiRefreshBongSu && onUpdateAccount_doin==0){

                        heureumBhDoinCho1HooBongSu=1;
                        Account1.Refresh();
                    }

                    if (onUpdateAccount_doin==1){

                        /////////////////// 줄리아 포지션 바뀌었는지 확인
                        juliaYesEumyangIlchi=sql_rra_ibjangGo[6]*ibjang;
                        
                        if (juliaYesEumyangIlchi<=0 || hhJuliaIbjangBhBs !=0){

                            if (juliaYesEumyangIlchi<0){  // 줄리아 포지션 역향 발령시

                                juliaIbjangYucHyangRyung=1;

                                tal_jangjun_gesu=-1;
                                talHeureumHu_sqlDasiDocUmu=1;  // 다시 읽기 1 부여
                            }
                            
                            talHeureum=1;  // 탈출발생 유 처리
                            heureumBhDoinCho=1;	
                            heureumBhDoinCho1HooBongSu=1;
                        }

                        /////////////////// 수동개입 청산시 감지
                        /*
                        Account1.SetBalanceItem(jumunJoonCode,0);

                        hhBalanceCount=Account1.Balance.count;  // 결. 현재 잔고 수량.

                        if (hhBalanceCount==0){

                            talHeureum=0;
                            ibjang=0;
                        }
                        */
                    }
				}	
			}
			
            /////////////////// 청산부
			if (talHeureum==1){

                isNormalVV=false;

                if (talHeureum1Si_reFreshHu==0){

                    hhTonggwaJoong=800;
                    heureumBhDoinCho=0;
                    onUpdateAccount_doin=0;

                    ///////////////////
                    Account1.SetBalanceItem(jumunJoonCode,0);

                    hhBalanceCode=Account1.Balance.code;
                    hhBalanceCount=Account1.Balance.count;
                    hhBalanceIbjang=Account1.Balance.position;

                    if (hhBalanceCount>=1){

                        heureumJoongheureumTal=0; 
    
                        talHeureum2HooBongSu=0;
                        talHeureum=2;
                    }

                } else if (talHeureum1Si_reFreshHu==1){

                    if (heureumBhDoinCho==1){

                        hhTonggwaJoong=81;
                        heureumBhDoinCho=0;
                        onUpdateAccount_doin=0;
    
                        Account1.Refresh();
                    }

                    //////////////
                    heureumBhDoinCho1HooBongSu+=1;

                    if (heureumBhDoinCho1HooBongSu>=heureumBhDoinCho1HooDasiRefreshBongSu){

                        heureumBhDoinCho1HooBongSu=1;
                        Account1.Refresh();
                    }
    
                    if (onUpdateAccount_doin==1){
    
                        ///////////////////
                        Account1.SetBalanceItem(jumunJoonCode,0);

                        hhBalanceCode=Account1.Balance.code;
                        hhBalanceCount=Account1.Balance.count;
                        hhBalanceIbjang=Account1.Balance.position;

                        if (hhBalanceCount>=1){

                            heureumJoongheureumTal=0; 

                            talHeureum2HooBongSu=0;
                            talHeureum=2;
                        }
                    }
                }
			} 
            
            if (talHeureum==2){  // 청산 시작

                hhTonggwaJoong=82;

                if (hhBalanceIbjang==1){  // 현재 보유 포지션 매도시

                    Main.MessageList("talHeureum 2_1 분기 통과한.")
					
                    talHeureum=3;
					tal_jumunHoo_bongSu=1;
                    heureumBhDoinCho=1;
                    heureumBhDoinCho1HooBongSu=1;

                    //////////////////
                    tal_jangjun_gesuGyul=jumun_jangjun_gesu_juliaBhBsSi;

                    if (juliaIbjangYucHyangRyung==1){

                        tal_jangjun_gesuGyul=tal_jangjun_gesu;
                    } 
                    
                    //////////////////
					hhTalJumunGac=hhJuliaIbjangSiJuliaC-(CHg01_hanguc_soDongTick*tal_jangjun_gesuGyul);  // 청산 장전가
					
                    ////////////////// 수정- 너무 도망 갔을 시 수정
                    /*
                    hhTalJumunGacwaMarketCcha=Math.abs(hhTalJumunGac-hhJJc);
                    hhTalJumunGaCwaMarketCchaGesu=hhTalJumunGacwaMarketCcha*roundSiGobSu;  // 음양 영양

                    if (hhTalJumunGaCwaMarketCchaGesu>=hhTalJumunGaCwaMarketCcha_injungGesu){  // 16개 손잡이

                        hhTalJumunGac=hhJJc;  // 수정
                    }
                    */

					////////////////// hhTalJumunGac 보정
                    if (jumunGa_bojungHu==1){

                        if (hhTalJumunGac>hhBidC){
                            hhTalJumunGac=hhBidC+(CHg01_hanguc_soDongTick*1);
                        }
                    }

                    hhTalJumunGac=hhTalJumunGac.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);
                    talJumunHyang=1;

                    talJumunSiTalGac=hhTalJumunGac;
                    taljumunHoo_domang_orderReplace_ryung=0;

                    hhTonggwaJoong=821;
                    orderIDvvJ1=orderIDvv;
                    orderId_810=Account1.OrderBuy(hhBalanceCode,hhBalanceCount,hhTalJumunGac,2);

				} else if (hhBalanceIbjang==2){  // 현재 보유 포지션 매수시

                    Main.MessageList("talHeureum 2_2 분기 통과한.")
					
                    talHeureum=3;
					tal_jumunHoo_bongSu=1;
                    heureumBhDoinCho=1;
                    heureumBhDoinCho1HooBongSu=1;

                    //////////////////
                    tal_jangjun_gesuGyul=jumun_jangjun_gesu_juliaBhBsSi;

                    if (juliaIbjangYucHyangRyung==1){

                        tal_jangjun_gesuGyul=tal_jangjun_gesu;
                    } 

                    //////////////////
					hhTalJumunGac=hhJuliaIbjangSiJuliaC+(CHg01_hanguc_soDongTick*tal_jangjun_gesuGyul);  // 청산 장전가
					
                    ////////////////// 수정- 너무 도망 갔을 시 수정
                    /*
                    hhTalJumunGacwaMarketCcha=Math.abs(hhTalJumunGac-hhJJc);
                    hhTalJumunGaCwaMarketCchaGesu=hhTalJumunGacwaMarketCcha*roundSiGobSu;  // 음양 영양

                    if (hhTalJumunGaCwaMarketCchaGesu>=hhTalJumunGaCwaMarketCcha_injungGesu){  // 16개 손잡이

                        hhTalJumunGac=hhJJc;  // 수정
                    }
                    */

					////////////////// hhTalJumunGac 보정
                    if (jumunGa_bojungHu==1){

                        if (hhTalJumunGac<hhAskC){
                            hhTalJumunGac=hhAskC-(CHg01_hanguc_soDongTick*1);
                        }
                    }

                    hhTalJumunGac=hhTalJumunGac.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);
                    talJumunHyang=-1;

                    talJumunSiTalGac=hhTalJumunGac;
                    taljumunHoo_domang_orderReplace_ryung=0;

                    hhTonggwaJoong=822;
                    orderIDvvJ1=orderIDvv;
                    orderId_10=Account1.OrderSell(hhBalanceCode,hhBalanceCount,hhTalJumunGac,2);
				}  

            } else if (talHeureum==3){

                tal_jumunHoo_bongSu+=1;

                if (orderIDvv !=orderIDvvJ1){

                    if (isNormalVV==true){

                        talHeureum=4;

                    } else if (isNormalVV==false){

                        talHeureum=2;
                    }
                }
            } 
            
            if (talHeureum==4){  // 청산 중

                hhTonggwaJoong=823;
                tal_jumunHoo_bongSu+=1;

                //////////////
                talJumunSiTalGac_wa_hhC_cha=hhJJc-talJumunSiTalGac;

                if (taljumunHoo_domang_orderReplace_ryung==0){

                    if (ibjang==1000){

                        if (talJumunSiTalGac_wa_hhC_cha<=Math.abs(CHg01_hanguc_soDongTick*talJumunSiTalGa_domang_orderReplace_tickGesu)*-1){

                            taljumunHoo_domang_orderReplace_ryung=1;
                        }

                    } else if (ibjang==-1000){

                        if (talJumunSiTalGac_wa_hhC_cha>=Math.abs(CHg01_hanguc_soDongTick*talJumunSiTalGa_domang_orderReplace_tickGesu)){

                            taljumunHoo_domang_orderReplace_ryung=1;
                        }
                    }
                }

                //////////////
                if (heureumBhDoinCho==1){

                    heureumBhDoinCho=0;
                    onUpdateAccount_doin=0;

                    Account1.Refresh();
                }

                //////////////
                heureumBhDoinCho1HooBongSu+=1;

                if (heureumBhDoinCho1HooBongSu>=heureumBhDoinCho1HooDasiRefreshBongSu){

                    heureumBhDoinCho1HooBongSu=1;
                    Account1.Refresh();
                }

                //////////////
                if (onUpdateAccount_doin==1){

                    hhTonggwaJoong=83;

                    ////////// 미체결
                    hhUnfillOrder=Account1.SetUnfillOrderNumber(orderNumVV); 
                    unfill_orderNum=Account1.Unfill.orderNum;  // 미체결
                    unfill_count=Account1.Unfill.count;  // 미체결

                    Account1.SetBalanceItem(jumunJoonCode,0);
                    hhTalJung_balanceCount=Account1.Balance.count;

                    //////////////
                    if (hhTalJung_balanceCount==0){  // 청산 됐을시

                        hhTonggwaJoong=84;

                        if (ibjang==1000){

                            ibjangBhBs=100080;

                        } else if (ibjang==-1000){

                            ibjangBhBs=-100080;
                        }	

                        ibjang=0;  // 포지션 0 부여.
                        talHeureum=0;

                        Account1.Refresh();

                    } else {  // 청산 아직 안 됐을시
                    
                        /////////////////// 줄리아 포지션 바뀌었는지 확인
                        juliaYesEumyangIlchi=sql_rra_ibjangGo[6]*ibjang;

                        if (juliaYesEumyangIlchi>0 && Math.abs(hhJuliaIbjangBhBs)==1){
                            // //////// 청산 대기중인 포지션과 새로 발령된 줄리아 포지션이 일치할 시만 

                            talHeureum=0;

                            heureumJoongheureumTal+=1;

                            if (heureumJoongheureumTal%(14*4)==1){

                                heureumJoongheureumTal=0;  

                                Account1.OrderCancel(unfill_orderNum);  
                                // // 결. 청산 대기 중 주문 취소 // 이때 ibjang==1000 또는 -1000 임.
                            }

                        } else if (juliaYesEumyangIlchi<0 && Math.abs(hhJuliaIbjangBhBs)==1) {
                            // //////// 청산 대기중 줄리아 포지션이 역향 발령시- 적극 청산하고 sql 다시 읽기 부여 

                            talHeureumHu_sqlDasiDocUmu=1;  // 다시 읽기 1 부여

                            //////////////// 적극 청산
                            tal_jangjun_gesu=-1;

                            if (ibjang>0){

                                hhTalJumunGac=hhJJc-(CHg01_hanguc_soDongTick*tal_jangjun_gesu);

                            } else if (ibjang<0){

                                hhTalJumunGac=hhJJc+(CHg01_hanguc_soDongTick*tal_jangjun_gesu);
                            }

                            hhTalJumunGac=hhTalJumunGac.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);

                            orderId_tal_replace=Account1.OrderReplace(unfill_orderNum,unfill_count,hhTalJumunGac);

                        } else {  // 청산 대기중 갈래

                            if (tal_jumunHoo_bongSu>=tal_jumunHoo_orderReplace_jacBongSu && taljumunHoo_domang_orderReplace_ryung==1){
                                // // 청산이 안되고 있을 시 정정주문- 6봉 손잡이

                                hhTonggwaJoong=85;

                                tal_jumunHoo_bongSu=1;
                                
                                //////////////
                                taljumunHoo_domang_orderReplace_ryung=0;

                                if (ibjang==1000){

                                    talJumunSiTalGac=talJumunSiTalGac-(CHg01_hanguc_soDongTick*4);  // 4개 손잡이

                                } else if (ibjang==-1000){

                                    talJumunSiTalGac=talJumunSiTalGac+(CHg01_hanguc_soDongTick*4);
                                }

                                ////////////// 적극적 청산을 위한 주문가격 설정
                                if (ibjang>0){

                                    hhTalJumunGac=hhJJc-(CHg01_hanguc_soDongTick*1);

                                } else if (ibjang<0){

                                    hhTalJumunGac=hhJJc+(CHg01_hanguc_soDongTick*1);
                                }

                                hhTalJumunGac=hhTalJumunGac.toFixed(CHg01_hanguc_soDongTick_sosuJum_jarisu);
                                
                                //////////////
                                orderId_tal_replace=Account1.OrderReplace(unfill_orderNum,unfill_count,hhTalJumunGac);	
                            }
                        }
                    }
                } 
			}

            /////////////////// 청산 정리부
            if (Math.abs(ibjangBhBs)==10 || Math.abs(hhJuliaIbjangBhBs)==1){

                tal_jangjun_gesu=0;  // 처리일

                ibjangBhBsSiC=hhJuliaIbjangSiJuliaC;
                juliaIbjangYucHyangRyung=0;

				talHeureumHu_sqlDasiDocUmu=2;
                jn_jumunHoo_orderJe_hoisu=0;

            } else if (Math.abs(ibjangBhBs)==100080){  // 청산 됐다 신호 나왔을 시

				tal_jangjun_gesu=0;  // 처리일

				//////////////////// sql 다시 읽기 부여부- 포지션 진행중 줄리아 포지션 역향 발령시 등 
				if (talHeureumHu_sqlDasiDocUmu==1){  // juliaYesEumyangIlchi 등에서 음이 나왔을시 등

                    hhDocDoinIbjangGoAnneBun=sql_rra_ibjangGo[0]-1;  // 줄리아고 행 다시 읽기 가능 부여
					talHeureumHu_sqlDasiDocUmu=2;
				}

				////////////////////
                if (ibjangBhBs==100080){

                    hhSuic=hhJJc-ibjangBhBsSiC;

                } else if (ibjangBhBs==-100080){

                    hhSuic=ibjangBhBsSiC-hhJJc;
                }

				////////////////////
                hhSuicNu+=hhSuic;  // 누적 수익.
                // Main.MessageList("hhSuicNu=",hhSuicNu);

                hhTonggwaJoong=86;
                ibjang=0;  // 포지션 0 부여.
            }

			Main.MessageList("jn_jumunHoo_bongSu=",jn_jumunHoo_bongSu,"onUpdateAccount_doin= ",onUpdateAccount_doin," hhBalanceCount=",hhBalanceCount," ibjang=",ibjang," ibjangBhBs=",ibjangBhBs," jumunJoonCode=",jumunJoonCode," orderIDvv=",orderIDvv," isNormalVV=",isNormalVV," hhTonggwaJoong=",hhTonggwaJoong," hhJnibJumungaC=",hhJnibJumungaC," hhTalJumunGac=",hhTalJumunGac," talHeureum=",talHeureum," hhDocDoinIbjangGoAnneBun=",hhDocDoinIbjangGoAnneBun," sql_rra_ibjangGo[0]=",sql_rra_ibjangGo[0]);
            // Main.MessageList("현재봉 ibjang=",ibjang," ibjangBhBs=",ibjangBhBs," jumunJoonCode=",jumunJoonCode," orderNumVV=",orderNumVV," isNormalVV=",isNormalVV," order_errorMessage=",order_errorMessage," hhTonggwaJoong=",hhTonggwaJoong);
		}
    }
}




function Main_OnOrderResponse(OrderResponse)
{	
    isNormalVV=OrderResponse.isNormal;
    orderIDvv=OrderResponse.orderID;
	orderNumVV=OrderResponse.orderNum;
	orderCountVV=OrderResponse.orderCount;
    order_errorMessage=OrderResponse.error;

	Account1.SetUnfillOrderNumber(orderNumVV);  // 미체결 

    ////////////////////////// orderNum 저장
    if (OrderResponse.orderID==orderId_1){
            
        orderId_1_orderNum=OrderResponse.orderNum;

    } else if (OrderResponse.orderID==orderId_81){

        orderId_81_orderNum=OrderResponse.orderNum;

    } else if (OrderResponse.orderID==orderId_jn_replace){

        orderId_jn_replace_orderNum=OrderResponse.orderNum;

    } else if (OrderResponse.orderID==orderId_810){

        orderId_810_orderNum=OrderResponse.orderNum;

    } else if (OrderResponse.orderID==orderId_10){

        orderId_10_orderNum=OrderResponse.orderNum;

    } else if (OrderResponse.orderID==orderId_tal_replace){

        orderId_tal_replace_orderNum=OrderResponse.orderNum;
    }
}




function Main_OnNotifyFill(NotifyFill)
{
    ////////////////////////// 주문 응답시 코드 재부여
    if (NotifyFill.orderNum==orderId_1_orderNum){

        jumunJoonCode=NotifyFill.code;  

    } else if (NotifyFill.orderNum==orderId_81_orderNum){

        jumunJoonCode=NotifyFill.code;  

    } else if (NotifyFill.orderNum==orderId_jn_replace_orderNum){

        jumunJoonCode=NotifyFill.code;  

    } else if (NotifyFill.orderNum==orderId_810_orderNum){

        jumunJoonCode=NotifyFill.code;  

    } else if (NotifyFill.orderNum==orderId_10_orderNum){

        jumunJoonCode=NotifyFill.code;  

    } else if (NotifyFill.orderNum==orderId_tal_replace_orderNum){

        jumunJoonCode=NotifyFill.code;  
    }
}




function Main_OnUpdateAccount(sAccntNum, sItemCode, lUpdateID)
{
    if (lUpdateID==30000){

        onUpdateAccount_doin=1;
    }        
}

