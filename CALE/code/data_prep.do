clear all
* Restricted-access cohort data are not redistributed in this repository
* (see README "Data" section). Point RAWDATA at your local copy, either by
* setting the RAWDATA_DIR environment variable or editing the line below.
global RAWDATA : env RAWDATA_DIR
if "$RAWDATA" == "" {
    global RAWDATA "OAdataset"
}
cd "$RAWDATA"



*HRS (US)
use randhrs1992_2022v1.dta , replace
drop s*
tostring hhidpn , replace 
rename r1walk1w r1walk1a
rename r1walksw r1walksa
rename r1walkrw r1walkra
drop respagem_b  respagey_b *ecenreg *ecendiv *emstat
keep hhidpn *walk1a *walksa *walkra *timwlk r*iwendy *agey_b *agem_b radage_y radyear rabyear r*shlt *strok *alzhe *cancr *heart *lung *demen *arthr *diab *hibp *cholst *drink *smoken *psych *lbsatwlf  *depres *wtresp *wtcrnh ragender r*urbrur raracem rahispan r*cenreg r*cendiv *atotb *mstat raeduc 
reshape long r@walk1a r@walksa r@walkra r@timwlk r@iwendy r@agey_b r@agem_b r@shlt r@strok r@alzhe r@cancr r@heart r@lung r@demen r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@lbsatwlf  r@depres r@wtresp r@wtcrnh r@urbrur r@cenreg r@cendiv h@atotb r@mstat , i(hhidpn) j(wave)
replace rstrok = 1 if inlist(rstrok,1,2,3,4,5)
replace ralzhe = 1 if inlist(ralzhe,1,3,4,7)
replace ralzhe = 0 if inlist(ralzhe,0,7)
replace rcancr = 1 if inlist(rcancr,1,3,4,5)
replace rheart = 1 if inlist(rheart,1,3,4,5,6)
replace rlung = 1 if inlist(rlung,1,3,4,5,6)
replace rdemen = 1 if inlist(rdemen,1,3,4)
replace rarthr = 1 if inlist(rarthr,1,3,4,5,6)
replace rdiab = 1 if inlist(rdiab,1,3,4,5,6)
replace rhibp = 1 if inlist(rhibp,1,3,4,5,6)
replace rpsych = 1 if inlist(rpsych,1,3,4,5,6)
gen rarace = .
replace rarace = 1 if raracem == 1 & rahispan == 0
replace rarace = 2 if raracem == 2 & rahispan == 0
replace rarace = 3 if rahispan == 1 & raracem != 1 & raracem != 2
replace rarace = 4 if raracem == 3 & rahispan == 0
drop raracem rahispan
replace rurbrur=0 if rurbrur==2 | rurbrur==3
replace raeduc = 0 if raeduc == 1 | raeduc == 2 | raeduc == 3
replace raeduc = 1 if raeduc == 4 | raeduc == 5
* keep if ragey_b >= 40
* drop if wave<=3
gen isocountry = 840
gen dataset="HRS"
order isocountry hhidpn rwalksa rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b ragem_b radage_y radyear rshlt rstrok ralzhe rcancr rheart rlung rdemen rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres rwtresp rwtcrnh ragender rurbrur rarace rcenreg rcendiv hatotb rmstat raeduc dataset
ds
save usa.dta, replace 





*ELSI (Brazil)
use ELSI_English_2nd_wave_stata13.dta , replace
rename id2 id
rename idhousehold2 idhousehold
replace p6=. if p6==9
replace p6=1+p6 if p6!=.
replace p7=. if p7==9
replace p7=1+p7 if p7!=.
replace p37=. if p37==9
replace p37=1+p37 if p37!=.
append using ELSI_English_baseline_stata13.dta
replace p6=0 if p6==1
replace p6=1 if p6==2 | p6==3 | p6==4 
replace p6=. if p6==9
replace p7=0 if p7==1
replace p7=1 if p7==2 | p7==3 | p7==4
replace p7=. if p7==9
replace p37=0 if p37==1
replace p37=1 if p37==2 | p37==3 | p37==4
tostring id , gen(hhidpn)
rename age ragey_b
rename p6 rwalksa
rename p7 rwalk1a
rename p37 rwalkra
rename n52 rstrok
rename n46 rheart
rename n55 rlung
rename n56 rarthr
rename n60 rcancr
rename n63 ralzhe
rename n63_2 rdemen
rename n35 rdiab
rename n28 rhibp 
rename n44 rcholst
rename l24 rdrink
rename l30 rsmoken
rename n59 rdepres
rename s18 rlbsatwlf 
rename calibrated_weight rwtresp
rename f1 rurbrur
rename sex ragender
rename e9 rarace
rename region rcenreg
rename e7 rmstat 
rename ci5 raeduc
rename assets hatotb 
gen riwendy=year(ar4)
gen rtimwlk = (mf35s+mf38s)/2
replace rstrok=. if rstrok==9
replace rheart=. if rheart==9
replace rlung=. if rlung==9
replace rarthr=. if rarthr==9
replace rcancr=. if rcancr==9
replace ralzhe=. if ralzhe==9
replace rdemen=. if rdemen==9
replace rdiab=. if rdiab==9
replace rdiab=0 if rdiab==2
replace rhibp=. if rhibp==9
replace rhibp=0 if rhibp==2
replace rcholst=. if rcholst==9
replace rdepres=. if rdepres==9
replace rdrink=. if rdrink==9
replace rdrink=0 if rdrink==1
replace rdrink=1 if rdrink==2 | rdrink==3
replace rsmoken=. if rsmoken==9 | rsmoken==8
replace rsmoken=1 if rsmoken==2
replace rsmoken=0 if rsmoken==3
replace rtimwlk=. if rtimwlk>400
*keep if ragey_b >= 40
keep hhidpn riwendy ragey_b rwalksa rwalk1a rwalkra rstrok rheart rlung rarthr rcancr ralzhe rdemen rdiab rhibp rcholst rdrink rsmoken rlbsatwlf rdepres rtimwlk rwtresp rurbrur ragender rarace rcenreg hatotb rmstat raeduc
*label values 
gen wave=(riwendy!=.)
replace wave = 2 if wave ==0
replace riwendy=2020 if riwendy==.
gen rabyear=riwendy-ragey_b
replace ragender=2 if ragender==0
replace raeduc = . if raeduc >=88
replace raeduc = 0 if raeduc <=11
replace raeduc = 1 if raeduc != 0 & raeduc != .
gen isocountry = 76
gen dataset="ELSI"
order isocountry hhidpn rwalksa rwalk1a rwalkra rtimwlk wave riwendy ragey_b rstrok ralzhe rcancr rheart rlung rdemen rarthr rdiab rhibp rcholst rdrink rsmoken rlbsatwlf rdepres rwtresp rurbrur ragender rarace rcenreg hatotb rmstat raeduc dataset
ds
save brazil.dta , replace 





*Charls (China)
use H_CHARLS_D_Data.dta , replace
drop s*
rename ID hhidpn
rename *walk100a *walk1a
rename *walk1kma *walksa
rename *wspeed *timwlk 
rename *iwy *iwendy
rename *agey *agey_b
gen radage_y=radyear-rabyear
rename *stroke *strok
rename *cancre *cancr
rename *hearte *heart
rename *lunge *lung
rename *arthre *arthr
rename *diabe *diab
rename *hibpe *hibp 
rename *drinkl *drink
rename *psyche *psych
rename *satlife *lbsatwlf 
rename *depresl *depres
rename h1rural r1urbrur
rename h2rural r2urbrur
rename h3rural r3urbrur
rename h4rural r4urbrur
rename communityID rcenreg
rename r2wthhl rwtcrnh
rename hh1atotb h1atotb
rename hh2atotb h2atotb
rename raeducl raeduc 
drop *rxlung *rxheart *rxstrok *rxarthr *rxdiab *rxpsych  *trpsych
keep hhidpn *walk1a *walksa *timwlk r*shlt r*iwendy *agey_b radage_y radyear rabyear *strok *cancr *heart *lung *arthr *diab *drink *psych *lbsatwlf *depres *wtresp rwtcrnh ragender r*urbrur rcenreg *atotb *mstat raeduc
reshape long r@walk1a r@walksa r@timwlk r@shlt r@iwendy r@agey_b r@agem_b r@strok  r@cancr r@heart r@lung r@arthr r@diab r@drink r@psych r@lbsatwlf r@depres r@wtresp r@urbrur h@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b >= 40
* drop if wave==1
* label values rwalk1a rwalksa rcancr rlung rheart rstrok rarthr wave
label values wave 
replace rurbrur=1-rurbrur
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
gen isocountry = 156
gen dataset="CHARLS"
order isocountry hhidpn rwalksa rwalk1a rtimwlk wave riwendy rabyear ragey_b ragem_b radage_y radyear rshlt rstrok rcancr rheart rlung rarthr rdiab rdrink rpsych rlbsatwlf rdepres rwtresp rwtcrnh ragender rurbrur rcenreg hatotb rmstat raeduc dataset
ds
save china.dta, replace 





*ELSA (England)
use h_elsa_g3.dta , replace
drop s*
rename *walk100a *walk1a
rename *agey *agey_b
gen radage_y = radyear - rabyear
rename *alzhe *alzhee
rename *stroks *strok
rename *cancrs *cancr
rename *hearts *heart
rename *lungs *lung
rename *arthrs *arthr
rename *alzhs *alzhe
rename *demens *demen
rename *diabe *diab
rename *hibpe *hibp
rename *hchole *cholst
rename *lstsf *lbsatwlf
rename raeducl raeduc
tostring idauniq, gen(hhidpn) 
drop *fagey_b *rxlung *trcancr rachshlt rachheart *adiag* *rxhibp *rxdiab *rxdepres rachpsych rachdiab *trdepres
keep hhidpn *walk1a *walkra *wspeed r*shlt r*iwindy *agey_b radage_y radyear rabyear *strok *alzhe *cancr *heart *lung *arthr *demen *diab *hibp *cholst *drink *smoken *psych *lbsatwlf *depres *cwtresp *lwtresp ragender raracem *atotb *mstat raeduc
drop *scwtresp
reshape long r@walk1a r@walkra r@wspeed r@shlt r@iwindy r@agey_b r@strok r@alzhe r@cancr r@heart r@lung r@demen r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@lbsatwlf r@depres r@cwtresp r@lwtresp h@atotb r@mstat, i(hhidpn) j(wave)
*keep if ragey_b>=40
rename rwspeed rtimwlk
rename riwindy riwendy
rename rcwtresp rwtresp
rename rlwtresp rwtcrnh
rename raracem rarace

foreach v in rtimwlk rwtresp rwtcrnh rarace rwalk1a rwalkra rstrok ralzhe rcancr rheart rlung rdemen rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres rmstat raeduc {
    replace `v' = . if `v' < 0
}
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
 
gen isocountry = 826
gen dataset="ELSA"
order isocountry hhidpn rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b radage_y radyear rshlt rstrok ralzhe rcancr rheart rlung rdemen rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres rwtresp rwtcrnh ragender rarace hatotb rmstat raeduc dataset
ds
save england.dta, replace





*LASI (India)
use H_LASI_DAD_b1 , replace
keep prim_key r2hwalk100a r2hwalkra r2hiwy r2hagey r2hstroke r2hhearte r2halzdeme r2hdiabe r2hhibpe r2hpcholtot r2hdeprese r2hpsyche r2hfsatisl r2hdepresl r2hwtresp rabyear ragender r2hruralc r2hcity r2hmstat raeducl
rename r2h* r2*
merge 1:1 prim_key using H_LASI_a3.dta
drop s*
rename prim_key hhidpn
rename *walk100a *walk1a
rename *walkra *walkra 
rename *iwy *iwendy
rename *agey *agey_b
rename *wspeed *timwlk 
rename *stroke *strok
rename *cancre *cancr
rename *hearte *heart
rename *lunge *lung
rename *arthre *arthr
rename *alzdeme *alzhe
rename *diabe *diab
rename *hibpe *hibp
rename *pcholtot *cholst
rename *deprese *depres
rename *psyche *psych
rename *fsatisl *lbsatwlf
drop *depres
rename *depresl *depres
rename hh1rural r1urbrur
rename r2ruralc r2urbrur
rename *city *cenreg
rename raeducl raeduc
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
label values raeduc
drop *adiag* *rxstrok *rxarthr *rxheart *rxhibp *rxdiab *rxpsych *trpsych *nwtresp
keep hhidpn *walk1a *walkra *timwlk r*shlt r*iwendy *agey_b rabyear *strok *alzhe *cancr *heart *lung *arthr *diab *hibp *cholst *psych *lbsatwlf *depres *wtresp ragender *urbrur *cenreg *mstat raeduc
foreach var in r2heart r2strok r2alzhe r2walkra r2walk1a r1shlt r1walkra r1walk1a r1cancr r1lung r1heart r1strok r1arthr r1alzhe ragender r1urbrur r2urbrur r1cenreg r2cenreg r1mstat r2mstat r1diab r2diab r1hibp r2hibp r1cholst r2cholst r1depres r2depres r1psych r2psych r1lbsatwlf r2lbsatwlf {
    label values `var'
}
export delimited using "tempindia.xlsx", replace
clear
import delimited "tempindia.xlsx", clear stringcols(1)
reshape long r@walk1a r@walkra r@timwlk r@shlt r@iwendy r@agey_b r@strok r@alzhe r@cancr r@heart r@lung r@arthr r@diab r@hibp r@cholst r@psych r@lbsatwlf r@depres r@wtresp r@urbrur r@cenreg r@mstat , i(hhidpn) j(wave)
*keep if ragey_b>=40
replace rurbrur=1-rurbrur
gen isocountry = 356
gen dataset="LASI"
order isocountry hhidpn rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b rshlt rstrok ralzhe rcancr rheart rlung rarthr rdiab rhibp rcholst rpsych rlbsatwlf rdepres rwtresp ragender rurbrur rcenreg  rcenreg rcenreg rmstat raeduc dataset
ds
save india.dta, replace 





*MHAS (Mexico)) r1walksa r1walk1a r1walkra
use H_MHAS_c2.dta, replace 
drop s*
tostring unhhidnp, gen(hhidpn) 
rename r3wspeed rtimwlk
rename *iwy *iwendy
rename *agey *agey_b
gen radage_y=radyear-rabyear
rename *stroke *strok
rename *cancre *cancr
rename *hrtatte *heart
rename *rxresp *lung
rename *arthre *arthr
rename *diabe *diab
rename *hibpe *hibp
rename *lstsf3 *lbsatwlf
rename raeducl raeduc
rename *rural  *urbrur
drop *rxstrok *recstrok *reccancr *rxarthr *rxhibp *rxdiab
keep hhidpn *walk1a *walksa *walkra rtimwlk r*shlt r*iwendy *agey_b radage_y radyear rabyear *strok *cancr *heart *lung *arthr *diab *hibp *cholst *drink *smoken *lbsatwlf *depres *wtresp ragender *urbrur *atotb *mstat raeduc
reshape long r@walk1a r@walksa r@walkra r@shlt r@iwendy r@agey_b r@strok r@cancr r@heart r@lung r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@lbsatwlf r@depres r@wtresp h@urbrur h@atotb r@mstat , i(hhidpn) j(wave)
rename hurbrur rurbrur
replace rurbrur=1-rurbrur
*keep if ragey_b>=40
replace rabyear = riwendy - ragey_b if riwendy!=.
label values raeduc
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
gen isocountry = 484
gen dataset="MHAS"
order isocountry hhidpn rwalksa rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b radage_y radyear rshlt rstrok rcancr rheart rlung rarthr rdiab rhibp rcholst rdrink rsmoken rlbsatwlf rdepres rwtresp ragender rurbrur hatotb rmstat raeduc dataset
ds
save mexico.dta, replace 





*SHARE (European)
use GH_SHARE_g.dta, replace
drop s*
rename mergeid hhidpn
rename *walk100a *walk1a
rename *wspeed *timwlk
rename *iwy *iwendy
rename *agey *agey_b
rename *agem *agem_b
gen radage_y=radyear-rabyear
rename *alzdeme *alzhe
rename *hrtatt *heart
rename *lunge *lung
rename *arthre *arthr
rename *diabe *diab
rename *hibpe *hibp
rename *hchole *cholst
rename *drinkxw *drink
rename *psyche *psych 
rename *satlife_s *lbsatwlf
drop r2depres
rename *depress *depres
rename raeducl raeduc
rename *rural *urbrur
drop radiag* *rxheart *rxlung *chheart rach* *rxdiab *rxhibp *rxpsych hh*atotb
keep hhidpn *walk1a *walkra *timwlk r*shlt r*iwendy *agey_b *agem_b radage_y radyear rabyear *strok *alzhe *cancr *heart *lung *arthr *diab *hibp *cholst *drink *smoken *psych *lbsatwlf *depres  isocountry *wtresp ragender *urbrur *atotb *mstat raeduc
reshape long r@walk1a r@walkra r@timwlk r@shlt r@iwendy r@agey_b r@agem_b r@strok r@alzhe r@cancr r@heart r@lung r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@lbsatwlf r@depres r@wtresp h@urbrur  h@atotb r@mstat , i(hhidpn) j(wave)
rename hurbrur rurbrur
replace rurbrur=1-rurbrur
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
label values raeduc
* keep if ragey_b>=40
gen dataset="SHARE"
order isocountry hhidpn rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b ragem_b radage_y radyear rshlt rstrok ralzhe rcancr rheart rlung rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres rwtresp ragender rurbrur hatotb rmstat raeduc dataset
ds
save europe.dta, replace





* Australia (ALSA)
clear
cd "$RAWDATA/ALSA"

use Wave1.dta, replace 
rename seqnum1 hhidpn
gen r1walk1a=0 if wlkhlfml==1
replace r1walk1a=1 if wlkhlfml==2
gen r1iwendy = year( datew1 )
gen rabyear = year( dob )
rename age r1agey_b
rename hlthlife r1shlt
gen r1strok=1 if  morbid33==1 | morbid34==1
replace r1strok=0 if r1strok==.
rename cancer r1cancr
replace r1cancr=0 if r1cancr==2
gen r1heart=1 if morbid14==1 | morbid15==1
replace r1heart=0 if r1heart==.
rename morbid2 r1arthr 
rename diabete r1diab
replace r1diab=0 if r1diab==2
rename morbid18 r1cholst
gen r1drink=(freqalch>1)
gen r1smoken=(smoker==1)
gen r1psych=1 if  psychiat==1 | psycholg==1
replace r1psych=0 if r1psych==.
rename satlife r1lbsatwlf 
replace r1lbsatwlf=. if r1lbsatwlf==9
egen r1depres = rowmean(cesd1-cesd20)
replace r1depres = floor(r1depres)
replace r1depres =. if r1depres==9
gen ragender=0 if sex == 1
replace ragender=1 if sex == 2
gen r1urbrur =1 if city==1
replace r1urbrur=0 if city==2
replace  ttlasset=. if  ttlasset==9
rename ttlasset h1atotb
rename maritst r1mstat
rename qualif raeduc 
keep hhidpn r1walk1a r1iwendy rabyear r1agey_b r1shlt r1strok r1cancr r1heart r1arthr r1diab r1cholst r1drink r1smoken r1psych r1lbsatwlf r1depres ragender r1urbrur h1atotb r1mstat raeduc
save w1_alsa.dta, replace 



use Wave2_processed.dta, replace 

rename seqnum hhidpn

gen r2walk1a=0 if wlkhlfw2==1
replace r2walk1a=1 if wlkhlfw2==2

gen r2iwendy = year( datew2 )
gen rabyear = year( dob )
rename age2w2 r2agey_b
replace r2agey_b =r2iwendy-rabyear if r2agey_b==.
rename srhlthw2 r2shlt

gen r2strok = 0
foreach v of varlist adlmd* iadm* {
    replace r2strok = 1 if regexm(lower(`v'), "stroke")
}

gen r2cancr = 0
foreach v of varlist adlmd* iadm* {
    replace r2cancr = 1 if regexm(lower(`v'), "cancer")
}

gen r2lung = 0
foreach v of varlist adlmd* iadm* {
    replace r2lung = 1 if regexm(lower(`v'), "lung")
}

gen r2heart = 0
foreach v of varlist adlmd* iadm* {
    replace r2heart = 1 if regexm(lower(`v'), "heart")
}

gen r2alzhe = 0
foreach v of varlist adlmd* iadm* {
    replace r2alzhe = 1 if regexm(lower(`v'), "alzhe")
}

gen r2arthr = 0
foreach v of varlist adlmd* iadm* {
    replace r2arthr = 1 if regexm(lower(`v'), "arthr")
}

gen r2diab = 0
foreach v of varlist adlmd* iadm* {
    replace r2diab = 1 if regexm(lower(`v'), "diabete")
}

gen r2cholst = 0
foreach v of varlist adlmd* iadm* {
    replace r2cholst = 1 if regexm(lower(`v'), "cholest")
}

gen r2depres = 0
foreach v of varlist adlmd* iadm* {
    replace r2depres = 1 if regexm(lower(`v'), "depress")
}


gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw2 r2mstat
rename typquaw2 raeduc 
keep hhidpn r2walk1a r2iwendy rabyear r2agey_b r2shlt r2strok r2cancr r2lung r2heart r2alzhe r2arthr r2diab r2cholst r2depres ragender r2mstat raeduc
save w2_alsa.dta, replace 



use Wave3.dta, replace 

rename seqnum hhidpn

gen r3walk1a=1 if wlkhlfw3==2
replace r3walk1a=0 if wlkhlfw3==1

gen r3iwendy = year( dateintw3 )
gen rabyear = year( dob )
gen r3agey_b=r3iwendy-rabyear
rename srhw3 r3shlt

gen r3strok=1 if w3cdn57==1 | w3cdn59==1
replace r3strok=0 if r3strok!=1

gen r3cancr=1 if w3cdn6==1 | w3cdn7==1 | w3cdn12==1 | w3cdn22==1 | w3cdn34==1 | w3cdn43==1 | w3cdn52==1 | w3cdn56==1 
replace r3cancr=0 if r3cancr!=1

gen r3heart=1 if w3cdn25==1 | w3cdn26==1 
replace r3heart=0 if r3heart!=1

gen r3arthr=1 if w3cdn3==1 
replace r3arthr=0 if r3arthr!=1

gen r3lung = 0
foreach v of varlist w3oth63 whatfor* othad*  {
    replace r3lung = 1 if regexm(lower(`v'), "lung")
}

gen r3alzhe = 0
foreach v of varlist w3oth63 othproxw3 {
    replace r3alzhe = 1 if regexm(lower(`v'), "alzhe")
}

gen r3diab=1 if w3cdn14==1 
replace r3diab=0 if r3diab!=1

gen r3cholst=1 if w3cdn29==1 
replace r3cholst=0 if r3cholst!=1

gen r3drink=0 if frqalw3==1
replace r3drink=1 if frqalw3>1 | frqalw3!=.

gen r3smoken=1 if smokerw3==1
replace r3smoken=0 if smokerw3==2

egen r3depres = rowmean(cesd*)
replace r3depres = floor(r3depres)
replace r3depres =. if r3depres==9

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

gen r3urbrur =1 if cityw3==1
replace r3urbrur=0 if cityw3==2

replace  ttlassw3=. if  ttlassw3==9
rename ttlassw3 h3atotb

rename maritw3 r3mstat

keep hhidpn r3walk1a r3iwendy rabyear r3agey_b r3shlt r3strok r3cancr r3heart r3lung r3arthr r3diab r3cholst r3drink r3smoken r3depres ragender r3urbrur h3atotb r3mstat 
save w3_alsa.dta, replace 



use Wave4.dta, replace 

rename seqnum hhidpn

gen r4walk1a=1 if wlkhlfw4==2
replace r4walk1a=0 if wlkhlfw4==1

gen r4iwendy = year( datew4 )
gen rabyear = year( dob )
gen r4agey_b=r4iwendy-rabyear

rename srhlthw4 r4shlt

gen r4strok = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r4cancr = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r4heart = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r4arthr = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4arthr = 1 if regexm(lower(`v'), "arthritis")
    }
}

gen r4lung = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r4alzhe = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r4diab = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4diab = 1 if regexm(lower(`v'), "diabete")
    }
}

gen r4cholst = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4cholst = 1 if regexm(lower(`v'), "cholest")
    }
}

gen r4hibp = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r4depres = 0
foreach v of varlist morbi* prxre* causf* {
    capture confirm string variable `v'
    if !_rc {
        replace r4depres = 1 if regexm(lower(`v'), "depress")
    }
}

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw4 r4mstat

keep hhidpn r4walk1a r4iwendy rabyear r4agey_b r4shlt r4strok r4cancr r4heart r4lung r4arthr r4diab r4cholst r4hibp r4depres ragender r4mstat 
save w4_alsa.dta, replace 



use Wave5.dta, replace 
rename Seqnum hhidpn

gen r5walk1a=1 if wlkhlfw5==2
replace r5walk1a=0 if wlkhlfw5==1

gen r5iwendy = year( datew5 )
gen rabyear = year( dob )
gen r5agey_b=r5iwendy-rabyear

rename srhlthw5 r5shlt

gen r5strok = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r5cancr = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r5heart = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r5arthr = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5arthr = 1 if regexm(lower(`v'), "arthritis")
    }
}

gen r5lung = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r5alzhe = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r5diab = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5diab = 1 if regexm(lower(`v'), "diabete")
    }
}

gen r5cholst = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5cholst = 1 if regexm(lower(`v'), "cholest")
    }
}

gen r5hibp = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r5depres = 0
foreach v of varlist morbi* othopw* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r5depres = 1 if regexm(lower(`v'), "depress")
    }
}

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw5 r5mstat

keep hhidpn r5walk1a r5iwendy rabyear r5agey_b r5shlt r5strok r5cancr r5heart r5lung r5arthr r5diab r5cholst r5hibp r5depres ragender r5mstat 
save w5_alsa.dta, replace 



use Wave6.dta, replace 
rename seqnum hhidpn

gen r6walk1a=1 if wlkhlfw6==2
replace r6walk1a=0 if wlkhlfw6==1

gen r6iwendy = year( datew6 )
gen rabyear = year( dob )
gen r6agey_b=r6iwendy-rabyear

rename hlthliw6 r6shlt

gen r6strok=1 if cdn57_w6==1 | cdn59_w6==1
replace r6strok=0 if r6strok!=1 

gen r6cancr=1 if cancew6==1 
replace r6cancr=0 if r6cancr==2 

gen r6heart=1 if cdn25_w6==1 | cdn26_w6==1
replace r6heart=0 if r6heart!=1 & r6heart!=.

gen r6arthr=1 if cdn3_w6==1 
replace r6arthr=0 if cdn3_w6!=1

gen r6diab=1 if diabetw6==1 
replace r6diab=0 if diabetw6==2

gen r6hibp=1 if cdn29_w6==1 
replace r6hibp=0 if cdn29_w6!=1

gen r6cholst = 0
foreach v of varlist what* {
    capture confirm string variable `v'
    if !_rc {
        replace r6cholst = 1 if regexm(lower(`v'), "cholest")
    }
}

egen r6depres = rowmean(cesd*)
replace r6depres = floor(r6depres)
replace r6depres =. if r6depres==9

rename satlifw6 r6lbsatwlf

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw6 r6mstat
gen r6urbrur=1 if cityw6==1
replace r6urbrur=0 if cityw6==2
keep hhidpn r6walk1a r6iwendy rabyear r6agey_b r6shlt r6strok r6cancr r6heart r6arthr r6diab r6cholst r6hibp r6depres r6lbsatwlf ragender r6mstat r6urbrur
save w6_alsa.dta, replace 



use Wave7.dta, replace 
rename seqnum hhidpn

gen r7walk1a=1 if wlkhlfw7==2
replace r7walk1a=0 if wlkhlfw7==1

gen r7iwendy = year( datew7 )
gen rabyear = year( dob )
gen r7agey_b=r7iwendy-rabyear

rename hlthliw7 r7shlt

gen r7cancr=1 if cancew7==1 
replace r7cancr=0 if cancew7==2
replace r7cancr=. if cancew7==0

gen r7arthr=. if arthriw7==1 
replace r7arthr=0 if arthriw7==9
replace  r7arthr=1 if arthriw7!=1 & arthriw7!=9

gen r7heart = 0
foreach v of varlist cdn* {
    capture confirm string variable `v'
    if !_rc {
        replace r7heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r7lung = 0
foreach v of varlist cdn* {
    capture confirm string variable `v'
    if !_rc {
        replace r7lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r7strok = 0
foreach v of varlist cdn* {
    capture confirm string variable `v'
    if !_rc {
        replace r7strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r7alzhe = 0
foreach v of varlist cdn* othrrsw7 {
    capture confirm string variable `v'
    if !_rc {
        replace r7alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r7diab=1 if diabetw7==1 
replace r7diab=0 if diabetw7==2

gen r7hibp = 0
foreach v of varlist cdn* omed* {
    capture confirm string variable `v'
    if !_rc {
        replace r7hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r7cholst = 0
foreach v of varlist cdn* {
    capture confirm string variable `v'
    if !_rc {
        replace r7cholst = 1 if regexm(lower(`v'), "cholest")
    }
}

egen r7depres = rowmean(CESD*)
replace r7depres = floor(r7depres)
replace r7depres =. if r7depres==9

rename satlifw7 r7lbsatwlf

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2
rename ttlassw7 h7atotb
rename maritw7 r7mstat
gen r7urbrur=1 if cityw7==1
replace r7urbrur=0 if cityw7==2
keep hhidpn r7walk1a r7iwendy rabyear r7agey_b r7shlt r7strok r7cancr r7heart r7lung r7arthr r7alzhe r7diab r7cholst r7hibp r7depres r7lbsatwlf ragender r7mstat h7atotb r7urbrur
save w7_alsa.dta, replace 



use Wave8.dta, replace 

rename seqnum hhidpn

gen r8walk1a=1 if wlkhlfw8==2
replace r8walk1a=0 if wlkhlfw8==1

gen r8iwendy = year( IntDatew8 )
gen rabyear = year( dob )
gen r8agey_b=r8iwendy-rabyear

rename hlthw8 r8shlt

gen r8strok = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r8heart = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r8cancr = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r8arthr = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8arthr = 1 if regexm(lower(`v'), "arthritis")
    }
}

gen r8lung = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r8alzhe = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r8diab = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8diab = 1 if regexm(lower(`v'), "diabete")
    }
}


gen r8hibp = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r8cholst = 0
foreach v of varlist morbi* adlmd* iadm* {
    capture confirm string variable `v'
    if !_rc {
        replace r8cholst = 1 if regexm(lower(`v'), "chole")
    }
}

egen r8depres = rowmean(cesd*)
replace r8depres = floor(r8depres)
replace r8depres =. if r8depres==9

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw8 r8mstat

keep hhidpn r8walk1a r8iwendy rabyear r8agey_b r8shlt r8strok r8cancr r8heart r8lung r8arthr r8alzhe r8diab r8cholst r8hibp r8depres ragender r8mstat
save w8_alsa.dta, replace 



use Wave9.dta, replace 

rename SEQNUM hhidpn

gen r9walk1a=1 if WLKHLFW9==2
replace r9walk1a=0 if WLKHLFW9==1

gen r9iwendy = year( w9date )
gen rabyear = year( dob )
gen r9agey_b=r9iwendy-rabyear

rename HLTHLIW9 r9shlt

gen r9strok = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r9heart = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r9cancr = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r9arthr = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9arthr = 1 if regexm(lower(`v'), "arthritis")
    }
}

gen r9lung = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r9alzhe = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r9diab =1 if DIABETW9 == 1
replace r9diab =0 if DIABETW9 == 2

gen r9hibp = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r9cholst = 0
foreach v of varlist CDN* OTHRRSW* {
    capture confirm string variable `v'
    if !_rc {
        replace r9cholst = 1 if regexm(lower(`v'), "chole")
    }
}

egen r9depres = rowmean(CESD*)
replace r9depres = floor(r9depres)
replace r9depres =. if r9depres==9

rename SATLIFW9 r9lbsatwlf

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

gen r9urbrur =1 if CITYW9==1
replace r9urbrur =0 if CITYW9==2

rename MARITW9 r9mstat

rename TTLASSW9 h9atotb

keep hhidpn r9walk1a r9iwendy rabyear r9agey_b r9shlt r9strok r9cancr r9heart r9lung r9arthr r9alzhe r9diab r9cholst r9hibp r9depres r9lbsatwlf ragender r9mstat h9atotb r9urbrur
save w9_alsa.dta, replace 



use Wave10.dta, replace 

rename seqnum hhidpn

gen r10walk1a=1 if wlkhlfw10==2
replace r10walk1a=0 if wlkhlfw10==1

gen r10iwendy = year( Datew10 )
gen rabyear = year( dob )
gen r10agey_b=r10iwendy-rabyear

rename hlthw10 r10shlt

gen r10strok = 0
foreach v of varlist morbi*  {
    capture confirm string variable `v'
    if !_rc {
        replace r10strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r10heart = 0
foreach v of varlist morbi*  {
    capture confirm string variable `v'
    if !_rc {
        replace r10heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r10cancr = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r10arthr = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10arthr = 1 if regexm(lower(`v'), "arthritis")
    }
}

gen r10lung = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10lung = 1 if regexm(lower(`v'), "lung")
    }
}

gen r10alzhe = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

gen r10diab = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10diab = 1 if regexm(lower(`v'), "diabete")
    }
}

gen r10hibp = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

gen r10cholst = 0
foreach v of varlist morbi* {
    capture confirm string variable `v'
    if !_rc {
        replace r10cholst = 1 if regexm(lower(`v'), "chole")
    }
}

egen r10depres = rowmean(cesd*)
replace r10depres = floor(r10depres)
replace r10depres =. if r10depres==9

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

rename maritw10 r10mstat

keep hhidpn r10walk1a r10iwendy rabyear r10agey_b r10shlt r10strok r10cancr r10heart r10lung r10arthr r10alzhe r10diab r10cholst r10hibp r10depres ragender r10mstat

save w10_alsa.dta, replace 



use Wave11.dta, replace 

rename SEQNUM hhidpn

gen r11walk1a=1 if WLKHLFW11==2
replace r11walk1a=0 if WLKHLFW11==1

gen r11iwendy = year( DATEW11 )
gen rabyear = year( dob )
gen r11agey_b=r11iwendy-rabyear

rename HLTHLW11 r11shlt
rename STRW11 r11strok
rename CANW11 r11cancr
gen r11heart=1 if HCDNW11==1 | HCDN1W11==1 | HCDN4W11==1 
replace r11heart=0 if r11heart!=1
gen r11arthr=1 if ARTHW11==1 | ARTH2W11==1 | ARTH3W11==1 | ARTH4W11==1 
replace r11arthr=0 if r11arthr!=1

gen r11alzhe = 0
foreach v of varlist WOMCW* {
    capture confirm string variable `v'
    if !_rc {
        replace r11alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

rename DIAW11 r11diab
rename HCHW11 r11cholst
rename HBPW11 r11hibp


egen r11depres = rowmean(CESD*)
replace r11depres = floor(r11depres)
replace r11depres =. if r11depres==9

gen r11psych=0 if PSYCITW11==0 | PSYCLGW11==0
replace r11psych=1 if PSYCITW11==1 | PSYCLGW11==1 

rename SATLIFW11 r11lbsatwlf

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

gen r11urbrur =1 if CITYW11==1
replace r11urbrur =0 if CITYW11==2
rename TTLASSW11 h11atotb
rename MARITW11 r11mstat

keep hhidpn r11walk1a r11iwendy rabyear r11agey_b r11shlt r11strok r11cancr r11heart r11arthr r11alzhe r11diab r11cholst r11hibp r11psych r11depres r11lbsatwlf ragender r11urbrur h11atotb r11mstat

save w11_alsa.dta, replace 



use Wave12.dta, replace 

rename SEQNUM hhidpn

gen r12walk1a=1 if WLKHLFW12==2
replace r12walk1a=0 if WLKHLFW12==1

gen r12iwendy = year( DATEW12 )
gen rabyear = year( dob )
gen r12agey_b=r12iwendy-rabyear

rename HLTHLW12 r12shlt
rename STRW12 r12strok
rename CANW12 r12cancr
gen r12heart=1 if HCDNW12==1 | HCDN1W12==1 | HCDN4W12==1 
replace r12heart=0 if r12heart!=1
gen r12arthr=1 if ARTHW12==1 | ARTH2W12==1 | ARTH3W12==1 | ARTH4W12==1 
replace r12arthr=0 if r12arthr!=1

gen r12alzhe = 0
foreach v of varlist WOMCW* {
    capture confirm string variable `v'
    if !_rc {
        replace r12alzhe = 1 if regexm(lower(`v'), "alzhe")
    }
}

rename DIAW12 r12diab
rename HCHW12 r12cholst
rename HBPW12 r12hibp


egen r12depres = rowmean(CESD*)
replace r12depres = floor(r12depres)
replace r12depres =. if r12depres==9

gen r12psych=0 if PSYCITW12==0 | PSYCLGW12==0
replace r12psych=1 if PSYCITW12==1 | PSYCLGW12==1 

rename SATLIFW12 r12lbsatwlf

gen ragender=0 if sex == 1
replace ragender=1 if sex == 2

gen r12urbrur =1 if CITYW12==1
replace r12urbrur =0 if CITYW12==2
rename TTLASSW12 h12atotb
rename MARITW12 r12mstat

keep hhidpn r12walk1a r12iwendy rabyear r12agey_b r12shlt r12strok r12cancr r12heart r12arthr r12alzhe r12diab r12cholst r12hibp r12psych r12depres r12lbsatwlf ragender r12urbrur h12atotb r12mstat

save w12_alsa.dta, replace 



use Wave13.dta, replace 

rename SEQNUM hhidpn

gen r13walk1a=1 if WLKHLFW13==2
replace r13walk1a=0 if WLKHLFW13==1

gen r13iwendy = year( DATEW13 )
gen rabyear = year( dob )
gen r13agey_b=r13iwendy-rabyear

rename HLTHW13 r13shlt

gen r13strok = 0
foreach v of varlist MORBI*  {
    capture confirm string variable `v'
    if !_rc {
        replace r13strok = 1 if regexm(lower(`v'), "stroke")
    }
}

gen r13heart = 0
foreach v of varlist MORBI*  {
    capture confirm string variable `v'
    if !_rc {
        replace r13heart = 1 if regexm(lower(`v'), "heart")
    }
}

gen r13cancr = 0
foreach v of varlist MORBI* {
    capture confirm string variable `v'
    if !_rc {
        replace r13cancr = 1 if regexm(lower(`v'), "cancer")
    }
}

gen r13hibp = 0
foreach v of varlist MORBI* {
    capture confirm string variable `v'
    if !_rc {
        replace r13hibp = 1 if regexm(lower(`v'), "hypertension|blood pressure")
    }
}

egen r13depres = rowmean(CESD*)
replace r13depres = floor(r13depres)
replace r13depres =. if r13depres==9
gen ragender=0 if sex == 1
replace ragender=1 if sex == 2
gen r13urbrur =1 if CITYW13==1
replace r13urbrur =0 if CITYW13==2
rename MARITW13 r13mstat
keep hhidpn r13walk1a r13iwendy rabyear r13agey_b r13shlt r13strok r13cancr r13heart r13hibp r13depres ragender r13urbrur r13mstat
save w13_alsa.dta, replace 

*Append*
use w1_alsa.dta, clear 
merge 1:1 hhidpn using w2_alsa.dta
drop _merge
merge 1:1 hhidpn using w3_alsa.dta
drop _merge
merge 1:1 hhidpn using w4_alsa.dta
drop _merge
merge 1:1 hhidpn using w5_alsa.dta
drop _merge
merge 1:1 hhidpn using w6_alsa.dta
drop _merge
merge 1:1 hhidpn using w7_alsa.dta
drop _merge
merge 1:1 hhidpn using w8_alsa.dta
drop _merge
merge 1:1 hhidpn using w9_alsa.dta
drop _merge
merge 1:1 hhidpn using w10_alsa.dta
drop _merge
merge 1:1 hhidpn using w11_alsa.dta
drop _merge
merge 1:1 hhidpn using w12_alsa.dta
drop _merge
merge 1:1 hhidpn using w13_alsa.dta
drop _merge
replace ragender=ragender+1
replace r1shlt=. if r1shlt==9 | r1shlt==6
replace r3shlt=. if r3shlt==9 | r3shlt==6
replace r5shlt=. if r5shlt==9 | r5shlt==6
replace r8shlt=. if r8shlt==0
replace r1cancr=. if r1cancr==9 
replace r1diab=. if  r1diab==9
replace r12diab=. if  r12diab==2
replace r11cholst=. if r11cholst==2 
foreach v of varlist r*aeduc {
    replace `v' = . if `v' == 9
}
sort hhidpn
save alsa.dta, replace


clear
cd "$RAWDATA"

use alsa.dta, replace
sort hhidpn
tostring hhidpn , replace 
reshape long r@walk1a r@iwendy r@agey_b r@shlt r@strok r@alzhe r@cancr r@heart r@lung r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@lbsatwlf r@depres r@urbrur h@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b >= 40
replace raeduc=0 if raeduc==2
label values raeduc
replace rmstat=. if rmstat==0 | rmstat==9 | rmstat==99
gen isocountry = 036
gen dataset = "ALSA"
order isocountry hhidpn rwalk1a wave riwendy rabyear ragey_b rshlt rstrok ralzhe rcancr rheart rlung rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres ragender rurbrur hatotb rmstat raeduc dataset
ds
save australia.dta, replace 





*Japan
clear all
cd "$RAWDATA/NSJE"

use 06842-0001-Data.dta, replace 
tostring J1VID, gen(hhidpn1) force
rename J1VID ID
rename J1V172 r1walk1a
replace r1walk1a=. if r1walk1a==8
replace r1walk1a=0 if r1walk1a==1
replace r1walk1a=1 if r1walk1a!=0 & r1walk1a!=.
rename J1V008 r1agey_b
rename J1V181 r1shlt
rename J1V135 r1strok
rename J1V127 r1heart
rename J1V122 r1arthr
rename J1V129 r1diab
rename J1V126 r1hibp
rename J1V193 r1drink
replace r1drink=0 if r1drink==2
rename J1V196 r1smoken
replace r1smoken=0 if r1smoken==2
rename J1V386 r1lbsatwlf
rename J1V380 r1depres
replace r1depres = 0 if r1depres==2
rename J1V050 ragender
gen r1urbrur = 0 if mod(J1V004,10)==7
replace r1urbrur =1 if r1urbrur!=0
rename J1V393 h1atotb
rename J1V025 r1mstat
rename J1V009 raeduc
gen dataset="NSJE"
gen isocountry=392
gen r1iwendy=1987
keep isocountry ID hhidpn1 r1walk1a r1iwendy r1agey_b r1shlt r1strok r1heart r1arthr r1diab r1hibp r1drink r1smoken r1lbsatwlf r1depres ragender r1urbrur h1atotb r1mstat raeduc dataset
save NSJE87.dta, replace 



use 03407-0001-Data.dta, replace 
tostring ID, gen(hhidpn2) force
replace J2V172 = J2PR090 if J2V172==.
rename J2V172 r2walk1a
replace r2walk1a=. if r2walk1a==3
replace r2walk1a=0 if r2walk1a==1
replace r2walk1a=1 if r2walk1a!=0 & r2walk1a!=.
replace J2V008=J2PR022 if J2V008==.
rename J2V008 r2agey_b
rename J2V181 r2shlt
replace J2V568 = J2PR078 if J2V568==.
replace J2V568=. if J2V568==3
replace J2V568=0 if J2V568==2
rename J2V568 r2strok
replace J2V549 = J2PR077 if J2V549==.
replace J2V549=. if J2V549==3
replace J2V549=0 if J2V549==2
rename J2V549 r2heart
replace J2V626 = J2PR082 if J2V626==.
replace J2V626=. if J2V626==3
replace J2V626=0 if J2V626==2
rename J2V626 r2arthr
replace J2V578 = J2PR079 if J2V578==.
replace J2V578=. if J2V578==3 | J2V578==2
replace J2V578=0 if J2V578==4
rename J2V578 r2cancr
replace J2V539 = J2PR076 if J2V539==.
replace J2V539=. if J2V539==3
replace J2V539=0 if J2V539==2
rename J2V539 r2diab
replace J2V530 = J2PR075 if J2V530==.
replace J2V530=. if J2V530==3 
replace J2V530=0 if J2V530==2
rename J2V530 r2hibp
rename J2V193 r2drink
replace r2drink=0 if r2drink==2
replace J2V196=. if J2V196==3 
replace J2V196=0 if J2V196==2 
rename J2V196 r2smoken
rename J2V386 r2lbsatwlf
rename J2V380 r2depres
rename J2V050 ragender
gen r2urbrur = 0 if mod(J2V004,10)==7
replace r2urbrur =1 if r2urbrur!=0
rename J2V393 h2atotb
replace J2V025=J2PR025 if J2V025==.
rename J2V025 r2mstat
rename J2V009 raeduc
gen dataset="NSJE"
gen isocountry=392
gen r2iwendy=1990
keep isocountry ID hhidpn2 r2walk1a r2iwendy r2agey_b r2shlt r2strok r2heart r2arthr r2cancr r2diab r2hibp r2drink r2smoken r2lbsatwlf r2depres ragender r2urbrur h2atotb r2mstat raeduc dataset
save NSJE90.dta, replace 



use 04145-0001-Data.dta, replace 
tostring ID, gen(hhidpn3) force
replace J3V206 = J3P110 if J3V206==.
rename J3V206 r3walk1a
replace r3walk1a=. if r3walk1a==5
replace r3walk1a=0 if r3walk1a==1
replace r3walk1a=1 if r3walk1a!=0 & r3walk1a!=.
replace J3V018=J3P027 if J3V018==.
rename J3V018 r3agey_b
rename J3V221 r3shlt
replace J3V118 = J3P077 if J3V118==.
replace J3V118=. if J3V118==3
replace J3V118=0 if J3V118==2
rename J3V118 r3strok
replace J3V095 = J3P075 if J3V095==.
replace J3V095=. if J3V095==3
replace J3V095=0 if J3V095==2
rename J3V095 r3heart
replace J3V105 = J3P087 if J3V105==.
replace J3V105=. if J3V105==3
replace J3V105=0 if J3V105==2
rename J3V105 r3arthr
replace J3V121 = J3P080 if J3V121==.
replace J3V121=. if J3V121==3
replace J3V121=0 if J3V121==2
rename J3V121 r3cancr
replace J3V117 = J3P076 if J3V117==.
replace J3V117=. if J3V117==3
replace J3V117=0 if J3V117==2
rename J3V117 r3diab
replace J3V116=. if J3V116==3
replace J3V116=0 if J3V116==2
rename J3V116 r3hibp
replace J3V257=. if J3V257==3
replace J3V257=0 if J3V257==2
rename J3V257 r3drink
replace J3V260=. if J3V260==3
replace J3V260=0 if J3V260==2
rename J3V260 r3smoken
rename J3V270 r3lbsatwlf
rename J3V347 r3depres
rename J3V040 ragender
gen r3urbrur = 0 if mod(J3V004,10)==7
replace r3urbrur =1 if r3urbrur!=0
rename J3V378 h3atotb
rename J3V027 r3mstat
gen dataset="NSJE"
gen isocountry=392
gen r3iwendy=1993
keep isocountry ID hhidpn3 r3walk1a r3iwendy r3agey_b r3shlt r3strok r3heart r3arthr r3cancr r3diab r3hibp r3drink r3smoken r3lbsatwlf r3depres ragender r3urbrur h3atotb r3mstat dataset
save NSJE93.dta, replace 



use 26621-0001-Data.dta, replace 
destring ID, replace
tostring ID, gen(hhidpn4)
replace J4V216 = J4P110 if J4V216==.
rename J4V216 r4walk1a
replace r4walk1a=. if r4walk1a==5
replace r4walk1a=0 if r4walk1a==1
replace r4walk1a=1 if r4walk1a!=0 & r4walk1a!=.
replace J4V018=J4P022 if J4V018==.
rename J4V018 r4agey_b
replace J4V225=J4P116 if J4V225==.
rename J4V225 r4shlt
replace J4V127=J4P074 if J4V127==.
replace J4V127=. if J4V127==3
replace J4V127=0 if J4V127==2
rename J4V127 r4heart
replace J4V128=J4P075 if J4V128==.
replace J4V128=. if J4V128==3
replace J4V128=0 if J4V128==2
rename J4V128 r4arthr
replace J4V134=J4P081 if J4V134==.
replace J4V134=. if J4V134==3
replace J4V134=0 if J4V134==2
rename J4V134 r4cancr
replace J4V130=J4P077 if J4V130==.
replace J4V130=. if J4V130==3
replace J4V130=0 if J4V130==2
rename J4V130 r4diab
replace J4V129=J4P076 if J4V129==.
replace J4V129=. if J4V129==3
replace J4V129=0 if J4V129==2
rename J4V129 r4hibp
rename J4V262 r4drink
replace r4drink=0 if r4drink==2
rename J4V265 r4smoken
replace r4smoken=0 if r4smoken==2
rename J4V180 r4lbsatwlf
replace r4lbsatwlf=. if r4lbsatwlf==3
replace r4lbsatwlf=0 if r4lbsatwlf==2
rename J4V344 r4depres
rename J4V053 ragender
gen r4urbrur = 0 if mod(J4V004,10)==7
replace r4urbrur =1 if r4urbrur!=0
rename J4V373 h4atotb
replace J4V038=J4P024 if J4V038==.
rename J4V038 r4mstat
rename J4V037 raeduc
gen dataset="NSJE"
gen isocountry=392
gen r4iwendy=1996
keep isocountry ID hhidpn4 r4walk1a r4iwendy r4agey_b r4shlt r4heart r4arthr r4cancr r4diab r4hibp r4drink r4smoken r4lbsatwlf r4depres ragender r4urbrur h4atotb r4mstat raeduc dataset
save NSJE96.dta, replace 


use NSJE96.dta, replace 
merge 1:1 ID using NSJE90.dta
drop _merge
save NSJE9096.dta, replace 

use NSJE93.dta, replace 
merge 1:1 ID using NSJE87.dta
drop _merge
save NSJE8793.dta, replace 

**************************************************
*MAKE ID CONSISTENT
**************************************************
use 04145-0001-Data.dta, clear
gen double ID_raw = ID
gen str20 ID_std = ""
replace ID_std = string(round(ID_raw,1), "%12.0f") if ID_raw == floor(ID_raw)
replace ID_std = subinstr(string(round(ID_raw,0.01), "%12.2f"), ".", "", .) ///
    if ID_raw != floor(ID_raw)
replace ID_std = trim(ID_std)
drop ID
rename ID_std ID
save clean1.dta, replace
**************************************************
use 26621-0001-Data.dta, clear
gen str20 ID_std = trim(ID)
gen double ID_num = real(ID)
replace ID_std = string(round(ID_num,1), "%12.0f") if ID_num == floor(ID_num)
replace ID_std = subinstr(string(round(ID_num,0.01), "%12.2f"), ".", "", .) ///
    if ID_num != floor(ID_num)
replace ID_std = trim(ID_std)
drop ID
rename ID_std ID
save clean2.dta, replace
**************************************************
use clean1.dta, clear
merge 1:1 ID using clean2.dta
gen len = length(string(ID_raw, "%12.0f")) if _merge==1
tab len
keep if len==5
gen ID00=ID+"00"
keep ID00 ID_raw 
save add00.dta, replace
**************************************************
use NSJE8793.dta, clear
gen double ID_raw = ID
merge 1:1 ID_raw using add00.dta
drop _merge
replace ID = real(ID00) if ID00!=""
drop ID_raw ID00
gen double ID_raw = ID
gen str20 ID_std = ""
replace ID_std = string(round(ID_raw,1), "%12.0f") if ID_raw == floor(ID_raw)
replace ID_std = subinstr(string(round(ID_raw,0.01), "%12.2f"), ".", "", .) ///
    if ID_raw != floor(ID_raw)
replace ID_std = trim(ID_std)
drop ID
rename ID_std ID
save NSJE87_93.dta, replace 

use NSJE9096.dta,replace  
gen double ID_num = ID
gen str20 ID_std = trim(hhidpn4)
replace ID_std = string(round(ID_num,1), "%12.0f") if ID_num == floor(ID_num)
replace ID_std = subinstr(string(round(ID_num,0.01), "%12.2f"), ".", "", .) ///
    if ID_num != floor(ID_num)
replace ID_std = trim(ID_std)
drop ID
rename ID_std ID
merge 1:1 ID using NSJE87_93.dta
drop _merge

drop hhidpn1 hhidpn2 hhidpn3 hhidpn4 ID_num ID_raw
rename ID hhidpn
replace hhidpn= "NSJE" + hhidpn
reshape long r@walk1a r@iwendy r@agey_b r@shlt r@strok r@cancr r@heart r@arthr r@diab r@hibp r@drink r@smoken r@lbsatwlf r@depres r@urbrur h@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b >= 40
replace  ragey_b=. if ragey_b==888
gen rabyear = riwendy - ragey_b
replace rsmoken=. if rsmoken==8
replace rdrink=. if rdrink==8
order isocountry hhidpn rwalk1a wave riwendy rabyear ragey_b rshlt rstrok rcancr rheart rarthr rdiab rhibp rdrink rsmoken rlbsatwlf rdepres ragender rurbrur hatotb rmstat raeduc dataset
ds

save NSJE.dta, replace



*MIDJA
clear all
cd "$RAWDATA"

use 30822-0001-Data.dta, replace
rename J* r*
gen wave=1
gen r1iwendy=2008
rename r1SQ1 ragender
save japan_1.dta, replace
use 36427-0001-Data.dta, replace
gen wave=2
rename K1* r2*
gen r2iwendy=2011
rename r2SQ1 ragender
merge 1:1 MIDJA_IDS using japan_1.dta
tostring MIDJA_IDS , gen(hhidpn)
rename (r2SA11F r2SA11G r2SA11H r1SA10F r1SA10G r1SA10H) (r2walksa r2walk1a r2walkra r1walksa r1walk1a r1walkra)
rename (r2SA9Z r1SA8Z) (r2strok r1strok)
rename (r2SA10D r1SA9D)(r2heart r1heart)
rename (r2SA10E r1SA9E)(r2lung r1lung)
rename (r2SA10G r1SA9G) (r2arthr r1arthr)
rename (r2SQ2AGE r1SQ2AGE)(r2agey_b r1agey_b)
rename (r2SA1 r1SA1 )(r2shlt r1shlt)
rename (r1SA8X r2SA9X)(r1diab r2diab)
rename (r1SA8S r2SA9S)(r1hibp r2hibp)
rename (r1SA9C r2SA10C)(r1cholst r2cholst)
rename (r1SA8U r2SA9U)(r1drink r2drink)
rename (r1SB4 r2SB1)(r1smoken r2smoken)
rename (r1SQ6C r2SQ6C)(r1psych r2psych)
rename (r1SSATIS r2SSATIS)(r1lbsatwlf r2lbsatwlf)
rename (r1SA8T r2SA9T)(r1depres r2depres)
rename (r1SF1 r2SF1)(h1atotb h2atotb)
rename (r1SL1 r2SL1)(r1mstat r2mstat)
rename r1SQ3 raeduc
replace raeduc=r2SQ3 if raeduc==.
gen isocountry = 392
keep hhidpn *walksa *walk1a *walkra r*shlt r*iwendy *agey_b *strok *heart *lung *arthr *diab *hibp *cholst *drink *smoken *psych *lbsatwlf *depres *atotb *mstat raeduc isocountry ragender 
reshape long r@walksa r@walk1a r@walkra r@shlt r@iwendy r@agey_b r@strok r@heart r@lung r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@lbsatwlf r@depres h@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b>=40
replace rwalksa=. if rwalksa==8
replace rwalk1a=. if rwalk1a==8
replace rwalkra=. if rwalkra==8
replace rwalksa=0 if rwalksa==1
replace rwalk1a=0 if rwalk1a==1
replace rwalkra=0 if rwalkra==1 
replace rwalksa=1 if rwalksa!=0 & rwalksa!=.
replace rwalk1a=1 if rwalk1a!=0 & rwalk1a!=. 
replace rwalkra=1 if rwalkra!=0 & rwalkra!=. 
replace rshlt=round(rshlt/2)
replace rstrok=. if rstrok==8
replace rheart=. if rheart==8
replace rlung=. if rlung==8
replace rarthr=. if rarthr==8
replace rdiab=. if rdiab==8
replace rhibp=. if rhibp==8
replace rcholst=. if rcholst==8
replace rdrink=. if rdrink==8
replace rsmoken=. if rsmoken==8 | rsmoken==9 
replace rpsych=. if rpsych==8 | rpsych==9
replace rstrok=0 if rstrok==2
replace rheart=0 if rheart==2
replace rlung=0 if rlung==2
replace rarthr=0 if rarthr==2
replace rdiab=0 if rdiab==2
replace rhibp=0 if rhibp==2
replace rcholst=0 if rcholst==2
replace rdrink=0 if rdrink==2
replace rsmoken=0 if rsmoken==2
replace rpsych=0 if rpsych==2
gen dataset ="MIDJA"
replace wave = wave + 4
gen rurbrur = 1
gen rabyear = riwendy - ragey_b
order isocountry hhidpn rwalk1a wave riwendy rabyear ragey_b rshlt rstrok rheart rlung rarthr ragender rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres rurbrur hatotb rmstat raeduc dataset
ds
save MIDJA.dta, replace

*NSJE+MIDJA
use MIDJA.dta, replace
append using NSJE.dta
drop rwalksa rwalkra
replace raeduc=. if raeduc==99 | raeduc==98
replace raeduc=0 if raeduc==1 | raeduc==2 | raeduc==3 | raeduc==4 | raeduc==9 | raeduc==10 | raeduc==11 | raeduc==12 
replace raeduc=1 if raeduc==5 | raeduc==6 | raeduc==7 | raeduc==8 | raeduc==13 | raeduc==14 | raeduc==15 | raeduc==16 | raeduc==17 | raeduc==18 | raeduc==19 
label values raeduc
replace rmstat=. if rmstat==6 | rmstat==7 | rmstat==8 
replace rmstat=5 if rmstat==8
replace rmstat=4 if rmstat==7
replace rmstat=3 if rmstat==5
replace rmstat=2 if rmstat==4
label values rmstat
replace dataset="NSJE+MIDJA"
save japan.dta, replace





*KLoSA (Korea)
use H_KLoSA_e3.dta , replace
drop s*
tostring pid , gen(hhidpn)
rename *gooutb *walk1a
rename *bedb_k *walkra
rename *iwy *iwendy
rename *agey *agey_b
gen radage_y=radyear-rabyear
rename *stroke *strok
rename *cancre *cancr
rename *hearte *heart
rename *lunge *lung
rename *arthre *arthr
rename *diabe *diab
rename *hibpe *hibp
rename *psyche *psych
rename *satwlife_k *lbsatwlf 
rename *depresl *depres
rename raeducl raeduc
rename *rural *urbrur
rename *region_k *cenreg
drop *adiag* *rxcancr *rxlung *rxheart *rxstrok *rxarthr *rxdiab *rxhibp *rxpsych
keep hhidpn *walk1a *walkra r*shlt r*iwendy *agey_b radage_y radyear rabyear *strok *cancr *heart *lung *arthr *diab *hibp *drink *psych *smoken *lbsatwlf *depres *wtresp ragender *urbrur *cenreg *atotb *mstat raeduc 
drop *lwtresp
reshape long r@walk1a r@walkra r@shlt r@iwendy r@agey_b r@strok r@cancr r@heart r@lung r@arthr r@diab r@hibp r@drink r@psych r@smoken r@lbsatwlf r@depres  r@wtresp r@urbrur r@cenreg r@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b>=40
rename ratotb hatotb 
replace rurbrur=1-rurbrur
gen isocountry = 410
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
label values raeduc
gen dataset="KLOSA"
order isocountry hhidpn rwalk1a rwalkra wave riwendy rabyear ragey_b radage_y radyear rshlt rstrok rcancr rheart rlung rarthr rdiab rhibp rdrink rpsych rsmoken rlbsatwlf rdepres rwtresp ragender rurbrur rcenreg hatotb rmstat raeduc dataset
ds
save korea.dta, replace




*Creles (Costa Rica) 
use H_CRELES.dta , replace
drop s*
merge 1:1 idsujeto using CRELES_survival.dta 
keep if _merge==3
drop _merge 
tostring hhid , gen(hhidpn)
rename *iwy *iwendy
rename *agey *agey_b
rename yrdeath radyear
rename agedeath radage_y
rename *stroke *strok
rename *cancre *cancr
rename *hearte *heart
rename *lunge *lung
rename *arthre *arthr
rename *diabe *diab
rename *hibpe *hibp 
rename *psyche *psych
rename *rural *urbrur
rename *region_cr *cenreg
rename raeducl raeduc
keep hhidpn *walksa *walkra r*shlt r*iwendy *agey_b radage_y radyear rabyear *strok *cancr *heart *lung *arthr r*diab r*hibp r*cholst r*drink r*smoken r*psych *wtresp ragender r*urbrur r*cenreg h*atotb r*mstat raeduc
* *timwlk *alzhe *demen r@alzhe r@demen  r@timwlk r@agem_b
reshape long r@walksa r@walkra r@shlt r@iwendy r@agey_b r@strok r@cancr r@heart r@lung r@arthr r@diab r@hibp r@cholst r@drink r@smoken r@psych r@wtresp r@urbrur r@cenreg h@atotb r@mstat , i(hhidpn) j(wave)
* keep if ragey_b >= 40
replace rurbrur=1-rurbrur
replace raeduc = 0 if raeduc == 1 | raeduc ==2
replace raeduc = 1 if raeduc == 3
label values raeduc
gen isocountry = 188
gen dataset="CRELES"
order isocountry hhidpn rwalksa rwalkra wave riwendy rabyear ragey_b radage_y radyear rshlt rstrok rcancr rheart rlung rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rwtresp ragender rurbrur rcenreg hatotb rmstat raeduc dataset
ds
save costarica.dta, replace 
 





*Afirca
use HAALSI_W1-3_Longitudinal_Dataset.dta, replace
rename prim_key hhidpn
rename w1ps004 wwalk1a
replace wwalk1a=. if wwalk1a==-98
replace wwalk1a=. if wwalk1a==-97
rename *c_pf_diff_walk *walkra 
replace w2walkra=. if w2walkra==-97
replace w3walkra=. if w3walkra==-97
rename *pt002 *timwlk 
rename *gh001 *shlt
rename *c_int_year *iwendy
rename *c_rage_calc *agey_b
replace w1bd001_year = w2bd001_year if w1bd001_year==.
rename w1bd001_year rabyear
rename *cm025 *strok
rename *cm204 *cancr
rename *cm038 *heart
rename *cm010 *diab
rename *cm002 *hibp
rename *cm046 *cholst
rename *cm068 *drink
rename *cm061 *smoken
rename *sw001 *lbsatwlf
rename w1cd001 w1depres
rename *cd206 *depres
rename *fa001 *atotb 
rename *c_bd_mar *mstat
replace w1mstat=8 if w1mstat==0
replace w1mstat=6 if w1mstat==1
replace w1mstat=7 if w1mstat==2
replace w1mstat=1 if w1mstat==3
replace w2mstat=8 if w2mstat==0
replace w2mstat=6 if w2mstat==1
replace w2mstat=7 if w2mstat==2
replace w2mstat=1 if w2mstat==3
replace w3mstat=8 if w3mstat==0
replace w3mstat=6 if w3mstat==1
replace w3mstat=7 if w3mstat==2
replace w3mstat=1 if w3mstat==3
replace w1bd036=. if w1bd036<0
gen raeduc = inlist(w1bd036, 15,16,21,22)
keep hhidpn wwalk1a *walkra *timwlk w*shlt w*iwendy *agey_b rabyear *strok *cancr *heart *diab *hibp *cholst *drink *smoken *lbsatwlf *depres *atotb *mstat raeduc
foreach var in w1shlt wwalk1a w1heart w1walkra w2timwlk w2heart w2walkra ///
              w3shlt w3strok rabyear w1timwlk w1strok w2shlt w2strok ///
              w2cancr w3cancr w3timwlk w3heart w3walkra w1lbsatwlf w2lbsatwlf w3lbsatwlf ///
			  w1diab w1hibp w1cholst w1drink w1smoken w1depres w1atotb w1mstat ///
			  w2diab w2hibp w2cholst w2drink w2smoken w2depres w2atotb w2mstat ///
			  w3diab w3hibp w3cholst w3drink w3smoken w3depres w3mstat {
				label values `var' 
				}
export delimited using "tempafrica.csv", replace
import delimited using "tempafrica.csv", clear
reshape long w@walkra w@timwlk w@shlt w@iwendy w@agey_b w@strok w@heart w@cancr w@diab w@hibp w@cholst w@drink w@smoken w@lbsatwlf w@depres w@atotb w@mstat, i(hhidpn) j(wave)
replace wwalk1a=.  if wave != 1 
replace wwalk1a=0 if wwalk1a==1 | wwalk1a==2
replace wwalk1a=1 if wwalk1a==3
replace wwalkra=0 if wwalkra==2
replace wwalk1a=1 if wwalkra==1 & wave==1
replace wcancr=. if wave != 2
replace wcancr=0 if wcancr == 2
replace wstrok=0 if wstrok == 2
replace wheart=0 if wheart == 2
replace wdiab=0 if wdiab == 2
replace whibp=0 if whibp == 2
replace wcholst=0 if wcholst == 2
replace wdrink=0 if wdrink== 2
replace wsmoken=0 if wsmoken == 2
replace wdepres=0 if wdepres == 2
rename wwalkra rwalkra
rename wwalk1a rwalk1a
rename wshlt rshlt
rename wtimwlk rtimwlk
rename wheart rheart
rename wstrok rstrok
rename wcancr rcancr
rename wdiab rdiab
rename whibp rhibp
rename wcholst rcholst
rename wdrink rdrink
rename wsmoken rsmoken
rename wlbsatwlf rlbsatwlf
rename wdepres rdepres
rename watotb hatotb
rename wmstat rmstat
rename wagey_b ragey_b
rename wiwendy riwendy
replace rhibp=. if rhibp<0
replace rcholst=. if rcholst<0
replace rdrink=. if rdrink<0
replace rlbsatwlf=. if rlbsatwlf<0
replace rdepres=. if rdepres<0
replace hatotb=. if hatotb<0
* keep if ragey_b>=40
gen isocountry = 710
gen dataset="HAALSI"
order isocountry hhidpn rwalk1a rwalkra rtimwlk wave riwendy rabyear ragey_b rshlt rstrok rcancr rheart rdiab rhibp rcholst rdrink rsmoken rlbsatwlf rdepres hatotb rmstat raeduc dataset
ds
save southafrica.dta, replace 






*Integrate

use usa.dta, replace 
append using brazil.dta , force 
append using china.dta , force 
append using costarica.dta , force 
append using england.dta , force 
append using korea.dta , force 
append using india.dta , force 
append using mexico.dta , force 
append using europe.dta , force 
append using southafrica.dta , force 
append using japan.dta , force 
append using australia.dta , force 

replace rshlt=. if rshlt<0
replace rstrok=. if rstrok<0
replace rcancr=. if rcancr<0
replace rheart=. if rheart<0
label values raeduc
foreach var in rwalksa rwalk1a rwalkra rshlt rstrok ralzhe rcancr rheart rlung rdemen rarthr rdiab rhibp rcholst rdrink rsmoken rpsych rlbsatwlf rdepres {
    label values `var'
}

replace radyear = . if radyear == .x
replace rabyear = riwendy - ragey_b if missing(rabyear) & !missing(ragey_b) & !missing(riwendy)
replace radage_y = radyear - rabyear if missing(radage_y) & !missing(radyear) & !missing(rabyear) 
replace riwendy = rabyear + ragey_b if missing(riwendy) & !missing(rabyear) & !missing(ragey_b)

* unique ID
sort isocountry hhidpn
egen id = group(isocountry hhidpn)
tostring id , gen(id_c) 
sort isocountry hhidpn wave
egen  id_iwy = group(isocountry hhidpn wave)
tostring id_iwy , replace 
sort isocountry id id_iwy 
bysort isocountry wave: egen wave_year = min(riwendy)

*Europe150 *Asia142 *Afirca002 *SouthAmerica005 *NorthAmerica019 *Oceania036
gen continent = .
replace continent = 150 if inlist(isocountry, 040, 056, 100, 191, 196, 203, 208, 233, 246, 250, 276, 300, 348, 372, 380, 428, 440, 442, 470, 528, 616, 620, 642, 703, 705, 724, 752, 756, 826)
replace continent = 142 if inlist(isocountry, 156, 356, 376, 410, 392)
replace continent = 002 if isocountry == 710
replace continent = 005 if isocountry == 076
replace continent = 019 if inlist(isocountry, 188, 484, 840)
replace continent = 009 if inlist(isocountry, 036)

*Country_name
gen str30 isocountry_c = ""
replace isocountry_c = "Australia"         if isocountry == 036
replace isocountry_c = "Austria"           if isocountry == 040
replace isocountry_c = "Belgium"           if isocountry == 056
replace isocountry_c = "Brazil"            if isocountry == 076
replace isocountry_c = "Bulgaria"          if isocountry == 100
replace isocountry_c = "China"             if isocountry == 156
replace isocountry_c = "Costa Rica"        if isocountry == 188
replace isocountry_c = "Croatia"           if isocountry == 191
replace isocountry_c = "Cyprus"            if isocountry == 196
replace isocountry_c = "Czech Republic"    if isocountry == 203
replace isocountry_c = "Denmark"           if isocountry == 208
replace isocountry_c = "Estonia"           if isocountry == 233
replace isocountry_c = "Finland"           if isocountry == 246
replace isocountry_c = "France"            if isocountry == 250
replace isocountry_c = "Germany"           if isocountry == 276
replace isocountry_c = "Greece"            if isocountry == 300
replace isocountry_c = "Hungary"           if isocountry == 348
replace isocountry_c = "India"             if isocountry == 356
replace isocountry_c = "Ireland"           if isocountry == 372
replace isocountry_c = "Israel"            if isocountry == 376
replace isocountry_c = "Italy"             if isocountry == 380
replace isocountry_c = "Japan"             if isocountry == 392
replace isocountry_c = "Korea"             if isocountry == 410
replace isocountry_c = "Latvia"            if isocountry == 428
replace isocountry_c = "Lithuania"         if isocountry == 440
replace isocountry_c = "Luxembourg"        if isocountry == 442
replace isocountry_c = "Malta"             if isocountry == 470
replace isocountry_c = "Mexico"            if isocountry == 484
replace isocountry_c = "Netherlands"       if isocountry == 528
replace isocountry_c = "Poland"            if isocountry == 616
replace isocountry_c = "Portugal"          if isocountry == 620
replace isocountry_c = "Romania"           if isocountry == 642
replace isocountry_c = "Slovakia"          if isocountry == 703
replace isocountry_c = "Slovenia"          if isocountry == 705
replace isocountry_c = "South Africa"      if isocountry == 710
replace isocountry_c = "Spain"             if isocountry == 724
replace isocountry_c = "Sweden"            if isocountry == 752
replace isocountry_c = "Switzerland"       if isocountry == 756
replace isocountry_c = "England"           if isocountry == 826
replace isocountry_c = "USA"               if isocountry == 840

*Country_iso3
gen str3 iso3c = ""
replace iso3c = "AUS" if isocountry == 036   // Australia
replace iso3c = "AUT" if isocountry == 040   // Austria
replace iso3c = "BEL" if isocountry == 056   // Belgium
replace iso3c = "BRA" if isocountry == 076   // Brazil
replace iso3c = "BGR" if isocountry == 100   // Bulgaria
replace iso3c = "CHN" if isocountry == 156   // China
replace iso3c = "CRI" if isocountry == 188   // Costa Rica
replace iso3c = "HRV" if isocountry == 191   // Croatia
replace iso3c = "CYP" if isocountry == 196   // Cyprus
replace iso3c = "CZE" if isocountry == 203   // Czech Republic
replace iso3c = "DNK" if isocountry == 208   // Denmark
replace iso3c = "EST" if isocountry == 233   // Estonia
replace iso3c = "FIN" if isocountry == 246   // Finland
replace iso3c = "FRA" if isocountry == 250   // France
replace iso3c = "DEU" if isocountry == 276   // Germany
replace iso3c = "GRC" if isocountry == 300   // Greece
replace iso3c = "HUN" if isocountry == 348   // Hungary
replace iso3c = "IND" if isocountry == 356   // India
replace iso3c = "IRL" if isocountry == 372   // Ireland
replace iso3c = "ISR" if isocountry == 376   // Israel
replace iso3c = "ITA" if isocountry == 380   // Italy
replace iso3c = "JPN" if isocountry == 392   // Japan
replace iso3c = "KOR" if isocountry == 410   // Korea (South)
replace iso3c = "LVA" if isocountry == 428   // Latvia
replace iso3c = "LTU" if isocountry == 440   // Lithuania
replace iso3c = "LUX" if isocountry == 442   // Luxembourg
replace iso3c = "MLT" if isocountry == 470   // Malta
replace iso3c = "MEX" if isocountry == 484   // Mexico
replace iso3c = "NLD" if isocountry == 528   // Netherlands
replace iso3c = "POL" if isocountry == 616   // Poland
replace iso3c = "PRT" if isocountry == 620   // Portugal
replace iso3c = "ROU" if isocountry == 642   // Romania
replace iso3c = "SVK" if isocountry == 703   // Slovakia
replace iso3c = "SVN" if isocountry == 705   // Slovenia
replace iso3c = "ZAF" if isocountry == 710   // South Africa
replace iso3c = "ESP" if isocountry == 724   // Spain
replace iso3c = "SWE" if isocountry == 752   // Sweden
replace iso3c = "CHE" if isocountry == 756   // Switzerland
replace iso3c = "GBR" if isocountry == 826   // England/UK
replace iso3c = "USA" if isocountry == 840   // USA

gen str20 continent_c = ""
replace continent_c = "Europe"          if continent == 150
replace continent_c = "Asia"            if continent == 142
replace continent_c = "Africa"          if continent == 002
replace continent_c = "South America"   if continent == 005
replace continent_c = "North America"   if continent == 019
replace continent_c = "Oceania"         if continent == 009

order continent continent_c isocountry isocountry_c iso3c wave wave_year riwendy id id_c id_iwy hhidpn rwalksa rwalk1a rwalkra rtimwlk rabyear radyear ragey_b ragem_b radage_y rshlt rstrok ralzhe rcancr rheart rlung rdemen rarthr rwtresp ragender rurbrur rarace rcenreg rcendiv

tab continent, m
tab isocountry, m

sort id wave
drop if missing(riwendy) & missing(rwalksa) & missing(rwalk1a) & missing(rwalkra)
sort id wave

save global40.dta, replace 















