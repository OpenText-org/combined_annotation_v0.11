<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:cl="http://www.opentext.org/ns/clause"
xmlns:pl="http://www.opentext.org/ns/paragraph" xmlns:wg="http://www.opentext.org/ns/word-group" xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:exsl="http://exslt.org/common"

>
  <xsl:param name="book">mark</xsl:param>
  <xsl:param name="cnum">1</xsl:param>

  <xsl:variable name="wgfile">
    <xsl:value-of select="concat('originalAnnotation/db/opentext/NT/',$book,'/wordgroup/',$book,'-wg-ch',$cnum,'.xml')"/>
  </xsl:variable>

  <xsl:variable name="basefile">
    <xsl:value-of select="concat('originalAnnotation/db/opentext/NT/',$book,'/base/',$book,'.xml')"/>
  </xsl:variable>

  <xsl:template match="/chapter">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="cl.clause"/>
    </xsl:copy>

  </xsl:template>

  <xsl:template match="/chapter/cl.clause">

    <xsl:variable name="words">
      <xsl:for-each select=".//w">
        <xsl:sort select="@xlink:href"/>
        <w ref="{@xlink:href}"/>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="wgroups">
      <xsl:copy-of select="document($wgfile)/chapter/wg.groups/wg.group"/>
    </xsl:variable>



    <xsl:variable name="first_word">
      <xsl:value-of select="exsl:node-set($words)/w[1]/@ref"/>
    </xsl:variable>

    <xsl:variable name="last_word">
      <xsl:value-of select="exsl:node-set($words)//w[position()=last()]/@ref"/>
    </xsl:variable>


    <clause>
      <xsl:copy-of select="@*"/>
      <clause_level>
        <xsl:apply-templates/>
      </clause_level>

      <wordgroup_level>

        <xsl:for-each select="exsl:node-set($words)/w">
          <xsl:apply-templates select="exsl:node-set($wgroups)/wg.group[wg.head/wg.word/@xlink:href=current()/@ref]"/>
        </xsl:for-each>

      </wordgroup_level>


      <xsl:for-each select="exsl:node-set($words)/w">
         <xsl:copy-of select="document($basefile)//w[@xml:id=current()/@ref]"/>
      </xsl:for-each>

    </clause>
  </xsl:template>

  <xsl:template match="wg.word">
    <w>
      <xsl:attribute name="ref">
          <xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </w>
  </xsl:template>

  <xsl:template match="*[starts-with(name(),'wg.') and not(name()='wg.word')]">
    <xsl:element name="{substring-after(name(.),'wg.')}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[starts-with(name(),'cl.')]">
    <xsl:element name="{substring-after(name(.),'cl.')}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[starts-with(name(),'pl.')]">
    <xsl:element name="{substring-after(name(.),'pl.')}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>



  <xsl:template match="w[ancestor::cl.clause or ancestor::wg.group]">
    <xsl:copy>
      <xsl:attribute name="ref">
          <xsl:value-of select="@xlink:href"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>




</xsl:stylesheet>
