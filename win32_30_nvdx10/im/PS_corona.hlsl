sampler2D DiffuseSampler : register(s1);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float3 r1;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = r0.xyz * i.texcoord1.xyz;
	r0.w = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.xyz = r0.xyz * i.texcoord1.xyz + -r0.www;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	o.xyz = r1.xxx * r0.xyz + r0.www;
	o.w = 1;

	return o;
}
