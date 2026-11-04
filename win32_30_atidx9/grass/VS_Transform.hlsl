float4 _fakedGrassNormal : register(c91);
float2 _vecCollParams : register(c73);
float4 _vecVehCollB : register(c84);
float4 _vecVehCollM : register(c85);
float4 _vecVehCollR : register(c86);
bool bVehCollEnabled : register(b10);
float4 fadeAlphaDistUmTimer : register(c87);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalUmScalars : register(c48);
float4 groundColor : register(c69);
row_major float4x4 matGrassTransform : register(c64);
float4 plantColor : register(c68);
float4 uMovementParams : register(c90);
float3 vecCameraPos : register(c70);
float3 vecPlayerPos : register(c71);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.x = globalUmScalars.x * i.color.x;
	r0.w = 1 + -i.color.z;
	r0.w = r0.w * globalUmScalars.y;
	r0.xyz = r0.xxw * uMovementParams.xxy;
	r0.w = 6.2831855 * i.color.y;
	r1.zw = uMovementParams.zw;
	r1.xyz = r1.zzw * globalUmScalars.zzw;
	r1.xyz = fadeAlphaDistUmTimer.zzz * r1.xyz + r0.www;
	r1.xyz = r1.xyz * 0.15915494 + 0.25;
	r1.xyz = frac(r1.xyz);
	r1.xyz = r1.xyz * 6.2831855 + -3.1415927;
	r1.xyz = r1.xyz * r1.xyz;
	r2.xyz = r1.yyz * -2.523985E-07 + 2.47609E-05;
	r2.xyz = r1.yyz * r2.xyz + -0.0013888397;
	r2.xyz = r1.yyz * r2.xyz + 0.04166664;
	r2.xyz = r1.yyz * r2.xyz + -0.5;
	r1.xyz = r1.xyz * r2.xyz + 1;
	r0.xyz = r1.xyz * r0.xyz + i.position.xyz;
	r1.xyz = r0.yyy * matGrassTransform[1].xyz;
	r0.xyw = r0.xxx * matGrassTransform[0].xyz + r1.xyz;
	r0.xyz = r0.zzz * matGrassTransform[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + matGrassTransform[3].xyz;
	r1.xyz = r0.xyz + -vecPlayerPos.xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = -r0.w + _vecCollParams.x;
	r0.w = saturate(r0.w * _vecCollParams.y);
	r0.w = r0.w * 0.5;
	r1.xyz = r1.xyz + 1E-05;
	r1.z = dot(r1.xyz, r1.xyz);
	r1.z = rsqrt(r1.z);
	r1.xy = r1.zz * r1.xy;
	r1.xy = r0.ww * r1.xy;
	r1.xy = r1.xy * i.color1.zz + r0.xy;
	if (bVehCollEnabled) {
		r1.zw = r1.xy + -_vecVehCollB.xy;
		r1.zw = r1.zw * _vecVehCollM.xy;
		r0.w = r1.w + r1.z;
		r0.w = saturate(r0.w * _vecVehCollM.w);
		r2.xy = _vecVehCollM.xy;
		r1.zw = r0.ww * r2.xy + _vecVehCollB.xy;
		r1.zw = -r1.zw + r1.xy;
		r2.xy = r1.zw * r1.zw;
		r0.w = r2.y + r2.x;
		r2.x = -r0.w + _vecVehCollR.y;
		r2.x = saturate(r2.x * _vecVehCollR.z);
		r2.y = r2.x * _vecVehCollR.x;
		r1.zw = r1.zw + 1E-05;
		r2.zw = r1.zw * r1.zw;
		r2.z = r2.w + r2.z;
		r2.z = rsqrt(r2.z);
		r1.zw = r1.zw * r2.zz;
		r1.zw = r1.zw * r2.yy;
		r1.xy = r1.zw * i.color1.zz + r1.xy;
		r1.z = lerp(r0.z, _vecVehCollR.w, r2.x);
		r1.w = 0.5;
		r1.w = r1.w * _vecVehCollR.x;
		r1.w = r1.w * r1.w;
		r0.w = (r0.w < r1.w) ? 1 : 0;
		r1.w = 0.25;
		r1.w = -r1.w + _vecVehCollR.w;
		r2.x = lerp(r1.z, r1.w, r0.w);
	} else {
		r2.x = r0.z;
	}
	r1.zw = r1.xy + -vecCameraPos.xy;
	r1.zw = r1.zw * r1.zw;
	r0.w = r1.w + r1.z;
	r0.w = saturate(r0.w * fadeAlphaDistUmTimer.y + fadeAlphaDistUmTimer.x);
	o.texcoord.w = r0.w * plantColor.w;
	r3 = r1.y * gWorldViewProj[1];
	r1 = r1.x * gWorldViewProj[0] + r3;
	r1 = r2.x * gWorldViewProj[2] + r1;
	o.position = r1 + gWorldViewProj[3];
	o.texcoord.xyz = plantColor.xyz;
	o.texcoord1.xyz = _fakedGrassNormal.xyz;
	o.texcoord1.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord2.xyz = r0.xyz;
	o.texcoord3.xyz = groundColor.xyz;
	o.texcoord3.w = i.color1.x;

	return o;
}
