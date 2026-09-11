/* FILE: AVIS/VERSION 1/BOOT/init.boot
   ROLE: VERSION_BOOTSTRAP
   VERSION: 1
*/

BEGIN BOOT VERSION_1
    /* Core system loading */
    LOAD_CONFIG("AVIS/VERSION 1/CONFIG/version.cfg");
    LOAD_SECURITY("AVIS/VERSION 1/SECURITY/policy.sec");
    LOAD_ENGINE("AVIS/VERSION 1/ENGINE/cyborg.engine");
    LOAD_INTERPRETER("AVIS/VERSION 1/INTERPRETER/loader.fvs");
    LOAD_MATRIX("AVIS/VERSION 1/ARTIFACTS/matrix.instance.art");

    /* Extension system */
    LOAD_EXTENSIONS("AVIS/VERSION 1/EXTENSIONS/loader.ext");

    /* Template system — must be installed BEFORE EVENT_INIT */
    LOAD_TEMPLATES("AVIS/VERSION 1/TEMPLATES/install.templates");
    CALL INSTALL_ALL();

    /* Runtime ignition */
    SIGNAL EVENT_INIT;
END BOOT
