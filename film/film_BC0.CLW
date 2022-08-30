  MEMBER('film.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
film_BC0:DctInit    PROCEDURE
film_BC0:DctKill    PROCEDURE
film_BC0:FilesInit  PROCEDURE
  END

Hide:Access:filmovi  CLASS(FileManager),TYPE               ! FileManager for filmovi
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:filmovi  CLASS(RelationManager),TYPE           ! RelationManager for filmovi
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:filmovi &Hide:Access:filmovi,AUTO,THREAD
_Hide:Relate:filmovi &Hide:Relate:filmovi,AUTO,THREAD


film_BC0:DctInit PROCEDURE
  CODE
  _Hide:Access:filmovi &= NEW(Hide:Access:filmovi)
  _Hide:Relate:filmovi &= NEW(Hide:Relate:filmovi)
  Relate:filmovi &= _Hide:Relate:filmovi


film_BC0:FilesInit PROCEDURE
  CODE
  _Hide:Relate:filmovi.Init


film_BC0:DctKill PROCEDURE
  CODE
  _Hide:Relate:filmovi.Kill
  DISPOSE(_Hide:Relate:filmovi)


Hide:Relate:filmovi.Init PROCEDURE
  CODE
  _Hide:Access:filmovi.Init
  SELF.Init(Access:filmovi,1)


Hide:Access:filmovi.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= fil:Record
  SELF.FileNameValue = 'filmovi'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= filmovi
  PARENT.Init
  Access:filmovi &= SELF


Hide:Access:filmovi.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:filmovi &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:filmovi.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(filmovi,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(fil:PK,'fil:PK',1)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:filmovi.Kill PROCEDURE

  CODE
  _Hide:Access:filmovi.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:filmovi &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:filmovi)                            ! destroy the file manager

