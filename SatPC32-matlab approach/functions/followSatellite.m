function followSatellite(arduinoCom, azimuthCom, chan)

    [Az, El, Sat] = satpc32(chan);
    stringAz = convertNumberToFormat(Az);
    stringEl = convertNumberToFormat(abs(El));
    fprintf(arduinoCom, ['e' stringEl]);
    orbit(Az, azimuthCom);
    fprintf(arduinoCom, ['a' stringAz]);