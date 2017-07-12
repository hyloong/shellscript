function elrang_install(){
    cd /root/download
    yum clean
    yum -y install unixODBC unixODBC-devel

    # install wx
    # wget http://sourceforge.net/projects/wxwindows/files/3.0.0/wxWidgets-3.0.0.tar.bz2
    # tar -xvf wxWidgets-3.0.0.tar.bz2
    # cd wxWidgets-3.0.0
    # ./configure --with-cocoa --prefix=/usr/local
    # ./configure --with-cocoa --prefix=/usr/local --with-macosx-version-min=10.9 --disable-shared --enable-unicode --enable-debug
    # make
    # make install
    # export PATH=/usr/local/bin:$PATH

    # get erlang
    tar -zxf otp_src_20.0.tar.gz
    cd otp_src_20.0
    export ERL_TOP=`pwd`
    export LANG=C

    # export MAKEFLAGS=-j8

    ./configure --enable-smp-support --enable-hipe --enable-threads --enable-kernel-poll  --enable-native-libs --enable-shared-zlib --enable-lock-counter
    make -j 4

    # test
    # make release_tests
    # cd release/tests/test_server
    # $ERL_TOP/bin/erl -s ts install -s ts smoke_test batch -s init stop

    # install
    make install

    # build doc
    # export PATH=$ERL_TOP/bin:$PATH
    # export FOP_HOME=/path/to/fop/dir
    make docs

    # build a debug Enabled Erlang RunTime System
    cd $ERL_TOP/erts/emulator
    export FLAVOR=smp
    make debug FLAVOR=$FLAVOR
    # other debug type
    # `$TYPE` is `opt`, `gcov`, `gprof`, `debug`, `valgrind`, or `lcnt` 
    # make $TYPE FLAVOR=$FLAVOR
}
