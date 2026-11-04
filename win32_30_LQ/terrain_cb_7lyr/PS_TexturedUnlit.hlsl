sampler2D TextureSampler_layer0 : register(s0);
sampler2D TextureSampler_layer1 : register(s2);
sampler2D TextureSampler_layer2 : register(s4);
sampler2D TextureSampler_layer3 : register(s6);
sampler2D TextureSampler_layer4 : register(s8);
sampler2D TextureSampler_layer5 : register(s10);
sampler2D TextureSampler_layer6 : register(s12);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 gDepthFxParams : register(c18);
row_major float4x4 gViewInverse : register(c12);
float4 globalFogColorN : register(c50);
float4 globalFogParams : register(c37);
float4 globalScalars : register(c35);
sampler2D lookupSampler : register(s14);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	r0 = tex2D(lookupSampler, i.texcoord.zw);
	r1.xyz = -r0.xyz + 1;
	r0.w = r1.y * r1.x;
	r1.w = r1.z * r0.w;
	r0.w = r0.z * r0.w;
	r2 = i.texcoord.xyxx * float4(1, 1, 0, 0) + float4(0, 0, 0, -1.3);
	r3 = tex2Dbias(TextureSampler_layer1, r2);
	r3.xyz = r0.www * r3.xyz;
	r4 = tex2Dbias(TextureSampler_layer0, r2);
	r3.xyz = r4.xyz * r1.www + r3.xyz;
	r1.xy = r0.yx * r1.xy;
	r4.xy = r1.zz * r1.xy;
	r0.zw = r0.zz * r1.yx;
	r0.x = r0.y * r0.x;
	r0.x = r1.z * r0.x;
	r1 = tex2Dbias(TextureSampler_layer2, r2);
	r1.xyz = r1.xyz * r4.xxx + r3.xyz;
	r3 = tex2Dbias(TextureSampler_layer3, r2);
	r1.xyz = r3.xyz * r0.www + r1.xyz;
	r3 = tex2Dbias(TextureSampler_layer4, r2);
	r1.xyz = r3.xyz * r4.yyy + r1.xyz;
	r3 = tex2Dbias(TextureSampler_layer5, r2);
	r2 = tex2Dbias(TextureSampler_layer6, r2);
	r0.yzw = r3.xyz * r0.zzz + r1.xyz;
	r0.xyz = r2.xyz * r0.xxx + r0.yzw;
	r1.w = globalScalars.x * i.texcoord3.w;
	r1.xyz = i.texcoord3.xyz;
	r0.w = 1;
	r0 = r0 * r1;
	r1.x = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.x = r1.x + 1E-05;
	r1.x = abs(r1.x) + 1E-05;
	r1.y = saturate(-i.texcoord2.w * gDepthFxParams.z + gDepthFxParams.w);
	r1.z = -r1.y + 1;
	r1.y = r1.z * gDepthFxParams.y + r1.y;
	r1.y = r1.y + -0.99999;
	r2.x = pow(r1.x, r1.y);
	r0.xyz = r0.xyz * r2.xxx + -globalFogColorN.xyz;
	o.w = r0.w;
	r1.xyz = -gViewInverse[3].xyz + i.texcoord1.xyz;
	r0.w = r1.z * globalFogParams.x;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = 1 / r1.x;
	r1.x = r1.x * globalFogParams.z;
	r1.y = r0.w * -1.442695;
	r1.y = exp2(r1.y);
	r1.y = -r1.y + 1;
	r1.z = 1 / r0.w;
	r0.w = -abs(r0.w) + 0.0001;
	r1.y = r1.z * r1.y;
	r1.y = r1.y * r1.x;
	r0.w = (r0.w >= 0) ? r1.x : r1.y;
	r0.w = r0.w * -globalFogParams.y;
	r0.w = r0.w * 1.442695;
	r0.w = saturate(exp2(r0.w));
	r0.xyz = r0.www * r0.xyz + globalFogColorN.xyz;
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = -r0.www + r0.xyz;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;

	return o;
}
