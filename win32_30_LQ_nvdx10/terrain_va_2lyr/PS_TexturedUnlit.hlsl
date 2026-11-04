sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s1);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord6 : TEXCOORD6;
	float2 texcoord5 : TEXCOORD5;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.xyz = -gViewInverse[3].xyz + i.texcoord3.xyz;
	r0.w = r0.z * globalFogParams.x;
	r0.x = dot(r0.xyz, r0.xyz);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = r0.x * globalFogParams.z;
	r0.y = r0.w * -1.442695;
	r0.y = exp2(r0.y);
	r0.y = -r0.y + 1;
	r0.z = 1 / r0.w;
	r0.w = -abs(r0.w) + 0.0001;
	r0.y = r0.z * r0.y;
	r0.y = r0.y * r0.x;
	r0.x = (r0.w >= 0) ? r0.x : r0.y;
	r0.x = r0.x * -globalFogParams.y;
	r0.x = r0.x * 1.442695;
	r0.x = saturate(exp2(r0.x));
	r0.y = saturate(-i.texcoord4.w * gDepthFxParams.z + gDepthFxParams.w);
	r0.z = -r0.y + 1;
	r0.y = r0.z * gDepthFxParams.y + r0.y;
	r1 = tex2D(TextureSampler_layer0, i.texcoord.xy);
	r2 = tex2D(TextureSampler_layer1, i.texcoord.zw);
	r0.z = r2.w * i.texcoord5.y;
	r3.xyz = lerp(r1.xyz, r2.xyz, r0.zzz);
	r1.w = globalScalars.x * i.texcoord6.w;
	r1.xyz = i.texcoord6.xyz;
	r3.w = 1;
	r1 = r1 * r3;
	r0.z = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.yz = r0.yz + float2(-0.99999, 1E-05);
	r0.z = abs(r0.z) + 1E-05;
	r2.x = pow(r0.z, r0.y);
	r0.yzw = r1.xyz * r2.xxx + -globalFogColorN.xyz;
	o.w = r1.w;
	r0.xyz = r0.xxx * r0.yzw + globalFogColorN.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = -r0.www + r0.xyz;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;

	return o;
}
