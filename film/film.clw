   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
     MODULE('FILM_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('FILM001.CLW')
Main                   PROCEDURE   !Wizard Application for C:\Users\Kruno\Desktop\CLAR_PYTH_PROJ\baza.dct
     END
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
filmovi              FILE,DRIVER('TOPSPEED'),PRE(fil),CREATE,BINDABLE,THREAD !                    
PK                       KEY(fil:id),NOCASE,OPT,PRIMARY    !                    
Record                   RECORD,PRE()
id                          LONG                           !                    
naslov                      STRING(50)                     !                    
drzava                      STRING(20)                     !                    
godina_nastanka             DECIMAL(4)                     !                    
zanr                        STRING(20)                     !                    
                         END
                     END                       

!endregion

Access:filmovi       &FileManager,THREAD                   ! FileManager for filmovi
Relate:filmovi       &RelationManager,THREAD               ! RelationManager for filmovi

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\film.INI', NVD_INI)                       ! Configure INIManager to use INI file
  DctInit
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

