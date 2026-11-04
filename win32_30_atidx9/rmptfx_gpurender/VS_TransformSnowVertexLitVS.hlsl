float gAmbientAmount : register(c102);
float4 gAmbientOcclusionEffect : register(c63);
float4 gColorTint : register(c96);
float gDiffuse : register(c101);
float4 gLightAmbient0 : register(c33);
float4 gLightAmbient1 : register(c34);
float4 gRadius : register(c93);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	float3 r3;
	float3 r4;
	r0.x = gRadius.x;
	r0.xyz = r0.xxx * float3(0, 0, 0.5) + i.texcoord.xyz;
	r1.xyz = -r0.xyz + gViewInverse[3].xyz;
	r2 = normalize(i.texcoord1.xyz);
	r3 = r1.yzx * r2.zxy;
	r3 = r2.yzx * r1.zxy + -r3.xyz;
	r4 = normalize(r1.xyz);
	r0.w = dot(r4.xyz, gWorldView[2].xyz);
	r0.w = saturate(r0.w * -0.5 + 0.5);
	r1.xyz = r2.xyz * gRadius.xxx;
	r2 = normalize(r3.xyz);
	r2 = r2.xyz * gRadius.xxx;
	r3.xy = float2(-0.5, -0.7) + i.texcoord2.xy;
	r1.xyz = r1.xyz * r3.yyy;
	r1.xyz = r3.xxx * r2.xyz + r1.xyz;
	r0.xyz = r0.xyz + r1.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.position = r1 + gWorldViewProj[3];
	r0.xyz = gLightAmbient0.xyz;
	r0.xyz = -r0.xyz + gLightAmbient1.xyz;
	r0.xyz = r0.www * r0.xyz + gLightAmbient0.xyz;
	r0.xyz = r0.xyz * gAmbientAmount.xxx;
	r0.w = 1 / gAmbientOcclusionEffect.y;
	r0.xyz = r0.www * r0.xyz;
	r0.xyz = r0.xyz * gDiffuse.xxx;
	o.color.xyz = r0.xyz * gColorTint.xyz;
	r0.xyz = gViewInverse[3].xyz + -i.texcoord.xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * 0.6666667;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * gColorTint.w;
	o.texcoord = i.texcoord2.xy;

	return o;
}
