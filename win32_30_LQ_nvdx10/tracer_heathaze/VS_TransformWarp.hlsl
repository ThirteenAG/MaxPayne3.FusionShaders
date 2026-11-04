row_major float4x4 gWorldView : register(c4);
row_major float4x4 gWorldViewProj : register(c8);
float4 globalDayNightEffects : register(c42);
float4 vCustomData[4] : register(c137);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 color : COLOR;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = vCustomData[0].xyz;
	r0.z = r0.z * -4.25 + 1;
	o.color.w = saturate(r0.y * -3.5 + r0.z);
	r1.xy = float2(1.05, 2);
	r0.y = vCustomData[1].w * -r1.x + r1.y;
	r0.y = max(r0.y, 0.1);
	r0.y = r0.y * vCustomData[2].z;
	r0.y = r0.y * vCustomData[0].w;
	r0.z = 1.8 * i.position.z;
	r0.z = min(r0.z, 5);
	r0.y = r0.y * 40 + -r0.z;
	r0.y = max(r0.y, 0);
	r1.xyz = float3(1, 256, 65536);
	r1.xyz = r1.xyz * vCustomData[2].yyy;
	r1.xyz = frac(r1.xyz);
	r1.xyz = r1.xyz * 0.01;
	r0.yzw = r0.yyy * r1.xyz;
	r1.x = globalDayNightEffects.w * globalDayNightEffects.w;
	r1.x = r1.x * 12 + 1;
	o.color.xyz = r0.yzw * r1.xxx;
	r0.xyz = r0.xxx * float3(1, 1, 0) + float3(0, 0, 1);
	r0.xyz = r0.xyz * i.position.xyz;
	r0.w = -r0.z * gWorldView[1].z;
	r0.w = r0.x * gWorldView[0].z + r0.w;
	r0.w = r0.y * gWorldView[2].z + r0.w;
	r0.w = r0.w + gWorldView[3].z;
	o.texcoord3 = -r0.w;
	r1 = gWorldViewProj[1];
	o.texcoord4 = -r0.z * r1 + gWorldViewProj[3];
	r1 = gWorldViewProj[1] * -i.position.z;
	r1 = i.position.x * gWorldViewProj[0] + r1;
	r1 = i.position.y * gWorldViewProj[2] + r1;
	o.texcoord2 = r1 + gWorldViewProj[3];
	r1 = -r0.z * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.y * gWorldViewProj[2] + r1;
	r0 = r0 + gWorldViewProj[3];
	o.position = r0;
	o.texcoord1 = r0;
	o.texcoord = i.texcoord.xy;

	return o;
}
