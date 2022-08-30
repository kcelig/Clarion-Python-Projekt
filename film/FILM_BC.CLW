  MEMBER('film.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('film_BC0.CLW')
film_BC0:DctInit             PROCEDURE
film_BC0:DctKill             PROCEDURE
film_BC0:FilesInit           PROCEDURE
    END
  END

DctInit PROCEDURE
  CODE
  film_BC0:DctInit
  film_BC0:FilesInit


DctKill PROCEDURE
  CODE
  film_BC0:DctKill

