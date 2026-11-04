cbuffer LaserParam : register(b1)
{
	float gMaxDisplacement : packoffset(c0);
	float gCameraDistanceAtMaxDisplacement : packoffset(c0.y);
	float4 LaserVisibilityMinMax : packoffset(c1);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.x = max(LaserVisibilityMinMax.x, 0);
	r0.x = min(r0.x, LaserVisibilityMinMax.y);
	r0.y = -(abs(i.texcoord3.y)) * abs(i.texcoord3.y) + 1;
	r1 = r0.y * i.texcoord4;
	r0 = r0.x * r1;
	r1.x = dot(r0.xyz, r0.www);
	r0.xyz = r1.xxx * float3(0.5, 0.5, 0.5) + r0.xyz;
	r1.x = saturate(i.texcoord3.w * 5);
	o = r0 * r1.x;

	return o;
}
