sampler2D PositionTexSampler : register(s1);
sampler2D VelocityTexSampler : register(s3);
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
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
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
	float4 r2;
	float3 r3;
	float3 r4;
	r0 = tex2Dlod(VelocityTexSampler, i.position);
	r1.xyz = normalize(r0.xyz);
	r0 = tex2Dlod(PositionTexSampler, i.position);
	r2.x = gRadius.x;
	r2.xyz = r2.xxx * float3(0, 0, 0.5) + r0.xyz;
	r0.xyz = -r0.xyz + gViewInverse[3].xyz;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * 0.6666667;
	r0.yzw = -r2.xyz + gViewInverse[3].xyz;
	r3 = r0.zwy * r1.zxy;
	r3 = r1.yzx * r0.wyz + -r3.xyz;
	r1.xyz = r1.xyz * gRadius.xxx;
	r4 = normalize(r0.yzw);
	r0.y = dot(r4.xyz, gWorldView[2].xyz);
	r0.y = saturate(r0.y * -0.5 + 0.5);
	r4 = normalize(r3.xyz);
	r3 = r4.xyz * gRadius.xxx;
	r0.zw = float2(-0.5, -0.7) + i.texcoord.xy;
	r1.xyz = r1.xyz * r0.www;
	r1.xyz = r0.zzz * r3.xyz + r1.xyz;
	r1.xyz = r1.xyz + r2.xyz;
	r2 = r1.y * gWorldViewProj[1];
	r2 = r1.x * gWorldViewProj[0] + r2;
	r1 = r1.z * gWorldViewProj[2] + r2;
	o.position = r1 + gWorldViewProj[3];
	r1.xyz = gLightAmbient0.xyz;
	r1.xyz = -r1.xyz + gLightAmbient1.xyz;
	r0.yzw = r0.yyy * r1.xyz + gLightAmbient0.xyz;
	r0.yzw = r0.yzw * gAmbientOcclusionEffect.yyy;
	r0.yzw = r0.yzw * gAmbientAmount.xxx;
	r1.x = 1 / gAmbientOcclusionEffect.y;
	r0.yzw = r0.yzw * r1.xxx;
	r0.yzw = r0.yzw * gDiffuse.xxx;
	o.color.xyz = r0.yzw * gColorTint.xyz;
	r0.y = r0.x * r0.x;
	r0.x = r0.x * r0.y;
	r0.x = min(r0.x, 1);
	o.color.w = r0.x * gColorTint.w;
	o.texcoord = i.texcoord.xy;

	return o;
}
