sampler2D BloodSamplerVS : register(s1);
float4 gAmbientOcclusionEffect : register(c63);
float4 gBloodData : register(c199);
row_major float4x4 gWorld : register(c0);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 globalScalars : register(c35);

struct VS_IN
{
	float4 position : POSITION;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 normal : NORMAL;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0 = float4(1, 1, 0, 0) * i.texcoord.zwzz;
	r0 = tex2Dlod(BloodSamplerVS, r0);
	r0.xyw = i.texcoord1.xyz * float3(1, -1, 1) + float3(0, 1, 0);
	r0.xyz = r0.zzz * r0.xyw;
	r0.xyz = r0.xyz * gBloodData.xxx + i.position.xyz;
	r1.xyz = r0.yyy * gWorld[1].xyz;
	r1.xyz = r0.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = r0.zzz * gWorld[2].xyz + r1.xyz;
	o.texcoord7 = r1.xyz + gWorld[3].xyz;
	r1.xyz = gWorld[1].xyz * i.normal.yyy;
	r1.xyz = i.normal.xxx * gWorld[0].xyz + r1.xyz;
	r1.xyz = i.normal.zzz * gWorld[2].xyz + r1.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	o.texcoord1.xyz = r0.www * r1.xyz;
	r1.xy = globalDayNightEffects.zw * i.color.xy;
	r0.w = r1.y + r1.x;
	r1.xz = float2(1, -1);
	r0.w = r0.w * globalScalars.z + r1.z;
	r0.w = gAmbientOcclusionEffect.y * r0.w + r1.x;
	r1.x = 1 / gAmbientOcclusionEffect.y;
	o.texcoord2.xy = r0.ww * r1.xx;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1.w = r0.w;
	o.texcoord = i.texcoord;
	o.texcoord2.zw = i.color.zw;
	o.texcoord6 = 0;

	return o;
}
