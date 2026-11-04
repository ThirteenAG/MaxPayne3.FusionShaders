cbuffer SkySystem : register(b1)
{
	float3 azimuthEastColor : packoffset(c0);
	float3 azimuthWestColor : packoffset(c1);
	float3 azimuthTransitionColor : packoffset(c2);
	float azimuthTransitionPosition : packoffset(c2.w);
	float3 zenithColor : packoffset(c3);
	float3 zenithTransitionColor : packoffset(c4);
	float3 zenithConstants : packoffset(c5);
	float hdrIntensity : packoffset(c5.w);
	float sphereReflectionSkyIntensity : packoffset(c6);
	float waterReflectionSkyIntensity : packoffset(c6.y);
	float mirrorReflectionSkyIntensity : packoffset(c6.z);
	float3 sunColor : packoffset(c7);
	float3 sunDiscColor : packoffset(c8);
	float sunHdrIntensity : packoffset(c8.w);
	float4 sunConstants : packoffset(c9);
	float3 sunDirection : packoffset(c10);
	float3 sunPosition : packoffset(c11);
	float3 cloudBaseColour : packoffset(c12);
	float3 cloudMidColour : packoffset(c13);
	float3 cloudShadowColour : packoffset(c14);
	float4 cloudDetailConstants : packoffset(c15);
	float4 cloudConstants1 : packoffset(c16);
	float4 cloudConstants2 : packoffset(c17);
	float4 cloudConstants3 : packoffset(c18);
	float4 smallCloudConstants : packoffset(c19);
	float3 smallCloudColorXHdrIntensity : packoffset(c20);
	float4 effectsConstants : packoffset(c21);
	float horizonLevel : packoffset(c22);
	float3 speedConstants : packoffset(c22.y);
	float starfieldIntensity : packoffset(c23);
	float3 moonDirection : packoffset(c23.y);
	float3 moonPosition : packoffset(c24);
	float moonIntensity : packoffset(c24.w);
	float3 lunarCycle : packoffset(c25);
	float3 moonColor : packoffset(c26);
	float4 moonTexConvert : packoffset(c27);
	float noiseFrequency : packoffset(c28);
	float noiseScale : packoffset(c28.y);
	float noiseThreshold : packoffset(c28.z);
	float noiseSoftness : packoffset(c28.w);
	float noiseDensityOffset : packoffset(c29);
	float noisePhase : packoffset(c29.y);
};

static const float4 icb[4] =
{
	float4(1, 0, 0, 0),
	float4(0, 1, 0, 0),
	float4(0, 0, 1, 0),
	float4(0, 0, 0, 1),
};

SamplerState NoiseSampler : register(s0);
Texture2D NoiseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	int4 r1;
	float4 r2;
	r0.xy = i.texcoord.xy + float2(-0.5, -0.5);
	r0.xy = r0.xy * noiseScale + float2(0.5, 0.5);
	r0.zw = noisePhase * float2(-0.00999999978, 0.00999999978);
	r0.xy = r0.xy * float2(0.0078125, 0.0078125) + r0.zw;
	r0.zw = r0.xy;
	r1.xyz = int3(0, 1065353216, 0);
	while (true) {
		r1.w = (r1.z >= 3) ? -1 : 0;
		if (r1.w != 0) break;
		r2 = NoiseSampler_tex.Sample(NoiseSampler, r0.zw);
		r2.xyz = r2.xyz + float3(-0.5, -0.5, -0.5);
		r2.xyz = r2.xyz + r2.xyz;
		r1.w = asint(dot(r2.xyz, icb[r1.z].xyz));
		r1.x = asint(asfloat(r1.w) * asfloat(r1.y) + asfloat(r1.x));
		r0.zw = r0.zw * noiseFrequency;
		r1.y = asint(asfloat(r1.y) * 0.5);
		r1.z = r1.z + 1;
	}
	r0.x = asfloat(r1.x) * 0.285714298 + 0.5;
	r0.y = -(noiseSoftness) + noiseThreshold;
	r0.z = noiseSoftness + noiseThreshold;
	r0.w = -(r0.y) + r0.z;
	r1.x = asint(-(r0.y) + r0.x);
	r0.w = 1 / r0.w;
	r0.w = saturate(r0.w * asfloat(r1.x));
	r1.x = asint(r0.w * -2 + 3);
	r0.w = r0.w * r0.w;
	o.x = r0.w * asfloat(r1.x);
	r0.yz = r0.yz + noiseDensityOffset;
	r0.z = -(r0.y) + r0.z;
	r0.y = -(r0.y) + r0.x;
	r0.z = 1 / r0.z;
	r0.y = saturate(r0.z * r0.y);
	r0.z = r0.y * -2 + 3;
	r0.y = r0.y * r0.y;
	o.y = r0.y * r0.z;
	o.w = 0;
	o.z = r0.x;

	return o;
}
