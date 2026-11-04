sampler2D DepthSampler : register(s5);
sampler2D ReflectanceSampler : register(s2);
sampler2D WaterSurfaceSampler : register(s3);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
row_major float4x4 gWorldViewProj : register(c8);
float2 nearFarClip : register(c203);
float4 shaderVariables : register(c200);
float4 waterColor : register(c201);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord6 : TEXCOORD6;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	float2 r3;
	r0 = gWorldViewProj[1].zxyw * i.texcoord6.y;
	r0 = i.texcoord6.x * gWorldViewProj[0].zxyw + r0;
	r0 = i.texcoord6.z * gWorldViewProj[2].zxyw + r0;
	r0 = r0 + gWorldViewProj[3].zxyw;
	r0.w = 1 / r0.w;
	r0.yz = r0.ww * r0.yz;
	r0.yz = r0.yz * float2(0.5, -0.5) + 0.5;
	r1 = tex2D(DepthSampler, r0.yz);
	r0.y = -nearFarClip.x + nearFarClip.y;
	r0.y = 1 / r0.y;
	r0.z = nearFarClip.y * -r0.y + r1.x;
	r0.y = r0.y * nearFarClip.y;
	r0.y = r0.y * -nearFarClip.x;
	r0.z = 1 / r0.z;
	r0.x = r0.y * r0.z + -r0.x;
	r1.x = max(r0.x, 0.01);
	r0.x = r1.x * -waterColor.w;
	r0.x = r0.x * 1.442695;
	r0.x = exp2(r0.x);
	r0.y = r0.x + -65504;
	r0.x = -r0.x + 1;
	r0.x = (r0.y >= 0) ? -65503 : r0.x;
	r1 = tex2D(WaterSurfaceSampler, i.texcoord.xy);
	r0.yzw = r1.xyz * 2 + -1;
	r0.yzw = i.texcoord1.xyz * 20 + r0.yzw;
	r0.yzw = r0.yzw + 1E-05;
	r1.xyz = normalize(r0.yzw);
	r0.yzw = 1E-05 + -i.texcoord3.xyz;
	r2 = normalize(r0.yzw);
	r0.y = dot(-r2.xyz, r1.xyz);
	r0.y = saturate(-r0.y + 1);
	r0.y = r0.y + 1E-05;
	r0.z = r0.y * r0.y;
	r0.z = r0.z * r0.z;
	r0.y = r0.z * r0.y;
	r3.y = -1;
	r0.z = -r3.y + -shaderVariables.z;
	r0.y = saturate(shaderVariables.z * r0.y + r0.z);
	r0.z = r0.y * -shaderVariables.y + -r3.y;
	r0.y = r0.y * shaderVariables.y;
	o.w = r0.z * r0.x;
	r0.z = dot(r2.xyz, r1.xyz);
	r0.z = r0.z + r0.z;
	r1.xyz = r1.xyz * -r0.zzz + r2.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r2 = normalize(r1.xyz);
	r0.z = saturate(r2.z);
	r0.z = r0.z + 1;
	r0.z = r0.z + r0.z;
	r0.z = 1 / r0.z;
	r0.zw = r2.xy * r0.zz + 0.5;
	r1.xy = -r0.zw + 1;
	r1.zw = 0;
	r1 = tex2Dlod(ReflectanceSampler, r1);
	r1.xyz = r1.xyz * r1.xyz;
	r1.xyz = r1.xyz * 16;
	r2 = r1.xyz * waterColor.xyz + -r1.xyz;
	r0.w = waterColor.w;
	r0.z = r0.w * shaderVariables.w;
	r1.xyz = r0.zzz * r2.xyz + r1.xyz;
	r1.xyz = waterColor.xyz * -r0.xxx + r1.xyz;
	r0.xzw = r0.xxx * waterColor.xyz;
	r0.xyz = r0.yyy * r1.xyz + r0.xzw;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = -r0.www + r0.xyz;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;

	return o;
}
