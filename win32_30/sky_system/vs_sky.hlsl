float3 azimuthEastColor : register(c130);
float3 azimuthTransitionColor : register(c132);
float azimuthTransitionPosition : register(c133);
float3 azimuthWestColor : register(c131);
float4 cloudConstants2 : register(c152);
float4 cloudConstants3 : register(c153);
float4 cloudDetailConstants : register(c150);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float hdrIntensity : register(c137);
float horizonLevel : register(c157);
float4 moonTexConvert : register(c165);
float4 smallCloudConstants : register(c154);
float3 speedConstants : register(c158);
float3 sunDirection : register(c145);
float3 zenithColor : register(c134);
float3 zenithConstants : register(c136);
float3 zenithTransitionColor : register(c135);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float2 texcoord4 : TEXCOORD4;
	float2 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
	float2 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	float3 r5;
	r0.xyz = azimuthTransitionColor.xyz;
	r1.xyz = -r0.xyz + azimuthWestColor.xyz;
	r2.zw = float2(0.5, 1);
	r0.w = r2.w + -azimuthTransitionPosition.x;
	r0.w = 1 / r0.w;
	r3 = gWorld[1].xyz * i.position.yyy;
	r3 = i.position.xxx * gWorld[0].xyz + r3.xyz;
	r3 = i.position.zzz * gWorld[2].xyz + r3.xyz;
	r3 = i.position.www * gWorld[3].xyz + r3.xyz;
	r4.xy = -gViewInverse[3].xy;
	r4.z = -horizonLevel.x;
	r4 = r3.xyz + r4.xyz;
	o.texcoord1 = r3.xyz;
	r3 = r4.xyz + 1E-05;
	r1.w = dot(r3.xyz, r3.xyz);
	r1.w = rsqrt(r1.w);
	r2.xy = r1.ww * r3.xz;
	r3.xy = r3.xy * -r1.ww + sunDirection.xy;
	r1.w = r2.x * -0.5 + 0.5;
	r2.x = r1.w + -azimuthTransitionPosition.x;
	r0.w = r0.w * r2.x;
	r1.xyz = r0.www * r1.xyz + azimuthTransitionColor.xyz;
	r0.w = 1 / azimuthTransitionPosition.x;
	r0.w = r0.w * r1.w;
	r4 = lerp(azimuthEastColor.xyz, r0.xyz, r0.www);
	r0.x = (r1.w < azimuthTransitionPosition.x) ? 1 : 0;
	r0.y = lerp(zenithConstants.y, zenithConstants.z, r1.w);
	r5 = lerp(r1.xyz, r4.xyz, r0.xxx);
	r0.xzw = -r5.xyz + zenithTransitionColor.xyz;
	r0.xzw = r0.xzw * r0.yyy;
	r1.xyz = lerp(r5.xyz, zenithTransitionColor.xyz, r0.yyy);
	r0.y = 1 / zenithConstants.x;
	r0.y = r0.y * abs(r2.y);
	r0.xyz = r0.yyy * r0.xzw + r5.xyz;
	r0.w = abs(r2.y) + -zenithConstants.x;
	r1.w = (abs(r2.y) < zenithConstants.x) ? 1 : 0;
	r2.x = r2.w + -zenithConstants.x;
	r2.x = 1 / r2.x;
	r0.w = r0.w * r2.x;
	r2.xyw = lerp(r1.xyz, zenithColor.xyz, r0.www);
	r4 = lerp(r2.xyw, r0.xyz, r1.www);
	r0.xyz = r4.xyz * hdrIntensity.xxx;
	r0.w = dot(r0.xyz, float3(0.3, 0.59, 0.11));
	o.texcoord2.xyz = r0.xyz;
	o.texcoord2.w = r0.w * cloudConstants3.x;
	r0.w = 0.1;
	r0.x = r0.w * cloudConstants2.y;
	r0.xy = r3.xy * r0.xx;
	r0.zw = i.texcoord.xy * 2 + -1;
	r0.zw = r0.zw * r0.zw;
	r0.z = r0.w + r0.z;
	r0.z = -r0.z + 1;
	o.texcoord.zw = -r0.xy * r0.zz + i.texcoord.xy;
	r0.xy = -0.5 + i.texcoord.xy;
	r1 = r0.xyyx * cloudDetailConstants.yyww + r2.z;
	r0.xy = r0.xy * smallCloudConstants.xx + r2.zz;
	r2.xyz = speedConstants.xyz;
	o.texcoord5 = r2.xx * smallCloudConstants.xx + r0.xy;
	o.texcoord3 = r2.zzyy * cloudDetailConstants.yyww + r1;
	o.texcoord4 = 64 * i.texcoord.zw;
	o.texcoord6 = 12 * i.texcoord.zw;
	r0 = gWorldViewProj[1] * i.position.y;
	r0 = i.position.x * gWorldViewProj[0] + r0;
	r0 = i.position.z * gWorldViewProj[2] + r0;
	r0 = i.position.w * gWorldViewProj[3] + r0;
	r1.x = r0.w + 1E-07;
	r1.x = 1 / r1.x;
	r1.xy = r0.xy * -r1.xx + moonTexConvert.xy;
	o.position = r0;
	r0.xy = r1.xy * moonTexConvert.zw;
	o.texcoord7 = r0.xy * 0.5 + 0.5;
	o.texcoord.xy = i.texcoord.xy;

	return o;
}
