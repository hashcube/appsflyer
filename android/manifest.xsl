<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:android="http://schemas.android.com/apk/res/android">

	<xsl:param name="appsFlyerDevKey" />

	<xsl:output indent="yes" />
	<xsl:template match="comment()" />

	<xsl:template match="meta-data[@android:name='CHANNEL']">
		<meta-data android:name="CHANNEL" android:value="amazon"/>
	</xsl:template>

	<xsl:template match="meta-data[@android:name='APPSFLYER_DEV_KEY']">
		<meta-data android:name="APPSFLYER_DEV_KEY" android:value="{$appsFlyerDevKey}"/>
	</xsl:template>

	<xsl:output indent="yes" />
	<xsl:template match="comment()" />

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
