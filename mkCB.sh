#!/bin/bash
TMPDIR="/tmp/codeBlcocksGen"

if [ ! -x $TMPDIR ]
then
  mkdir $TMPDIR
fi

cd $TMPDIR

CBVER="13.12"
CBPOSTFIX="-1"
WXVER="3.0.0"

getWxSources()
{
  cd $TMPDIR
  wget "http://downloads.sourceforge.net/project/wxwindows/$WXVER/wxWidgets-$WXVER.tar.bz2"
  tar -xf wxWidgets-$WXVER.tar.bz2
  rm wxWidgets-$WXVER.tar.bz2
}
makeWx()
{
  cd $TMPDIR/wxWidgets-$WXVER
  if [ -x $TMPDIR/wxWidgets-$WXVER-build ]
  then
    rm -rf $TMPDIR/wxWidgets-$WXVER-build
  fi
  mkdir $TMPDIR/wxWidgets-$WXVER-build
  cd $TMPDIR/wxWidgets-$WXVER-build
  $TMPDIR/wxWidgets-$WXVER/configure \
    --prefix=/usr \
    --libdir=/usr/lib64
  make
  if [ -x $TMPDIR/wxWidgets-$WXVER-pkg ]
  then
    rm -rf $TMPDIR/wxWidgets-$WXVER-pkg
  fi
  make install DESTDIR=$TMPDIR/wxWidgets-$WXVER-pkg
  rm -rf $TMPDIR/wxWidgets-$WXVER-build
  cd $TMPDIR/wxWidgets-$WXVER-pkg
  makepkg -l y -c n ../wxWidgets-$WXVER-x86_64-1dek.txz
  rm -rf $TMPDIR/wxWidgets-$WXVER-pkg
}
  
makeWxPKG()
{
  if [ -x $TMPDIR/wxWidgets-$WXVER ]
  then
    echo "Sources of WX is OK"
  else
    getWxSources
  fi
  makeWx
  
}

getCBSources()
{
  cd $TMPDIR
  wget "http://downloads.sourceforge.net/project/codeblocks/Sources/$CBVER/codeblocks_$CBVER$CBPOSTFIX.tar.gz"
  tar -xf codeblocks_$CBVER$CBPOSTFIX.tar.gz
  rm codeblocks_$CBVER$CBPOSTFIX.tar.gz
}
makeCB()
{
  cd $TMPDIR/codeblocks-$CBVER
  if [ -x $TMPDIR/codeblocks-$CBVER-build ]
  then
    rm -rf $TMPDIR/codeblocks-$CBVER-build
  fi
  mkdir $TMPDIR/codeblocks-$CBVER-build
  cd $TMPDIR/codeblocks-$CBVER-build
  $TMPDIR/codeblocks-$CBVER/configure \
    --prefix=/usr \
    --libdir=/usr/lib64 \
    --with-contrib-plugins=all
  make
  if [ -x $TMPDIR/codeblocks-$CBVER-pkg ]
  then
    rm -rf $TMPDIR/codeblocks-$CBVER-pkg
  fi
  make install DESTDIR=$TMPDIR/codeblocks-$CBVER-pkg
  rm -rf $TMPDIR/codeblocks-$CBVER-build
  cd $TMPDIR/codeblocks-$CBVER-pkg
  makepkg -l y -c n ../codeblocks-$CBVER-x86_64-1dek.txz
  rm -rf $TMPDIR/codeblocks-$CBVER-pkg
}
  
makeCBPKG()
{
  if [ -x $TMPDIR/codeblocks-$CBVER ]
  then
    echo "Sources of CB is OK"
  else
    getCBSources
  fi
  makeCB
  
}

if cat /var/log/packages/wxWidgets-$WXVER* >> /dev/null 
then
  echo "Package wxWidgex is already installed"	
else
  echo "No package wxWidgex is installed"	
  makeWxPKG
  installpkg $TMPDIR/wxWidgets-$WXVER*.t?z
fi

if cat /var/log/packages/codeblocks-$CBVER* >> /dev/null 
then
  echo "Package Code::Blocks is already installed"	
else
  echo "No package Code::Blocks is installed"	
  makeCBPKG
  installpkg $TMPDIR/codeblocks-$CBVER*.t?z
fi

